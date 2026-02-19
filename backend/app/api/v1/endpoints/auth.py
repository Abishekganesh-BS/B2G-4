from datetime import timedelta
from typing import Any
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.core import security
from app.core.config import settings
from app.api.deps import get_db
from app.models import User
from pydantic import BaseModel, EmailStr

router = APIRouter()

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    full_name: str | None = None

class Token(BaseModel):
    access_token: str
    token_type: str
    is_onboarded: bool
    full_name: str | None = None

@router.post("/register", response_model=Token)
async def register(user_in: UserCreate, db: AsyncSession = Depends(get_db)):
    print(f"[DEBUG REGISTER] Attempting to register: email={user_in.email}, full_name={user_in.full_name}")
    result = await db.execute(select(User).filter(User.email == user_in.email))
    existing = result.scalars().first()
    if existing:
        print(f"[DEBUG REGISTER] User already exists: id={existing.id}")
        raise HTTPException(
            status_code=400,
            detail="The user with this username already exists in the system.",
        )
    
    hashed = security.get_password_hash(user_in.password)
    print(f"[DEBUG REGISTER] Password hashed successfully, length={len(hashed)}")
    
    user = User(
        email=user_in.email,
        full_name=user_in.full_name,
        hashed_password=hashed,
        is_onboarded=False,
    )
    db.add(user)
    await db.commit()
    await db.refresh(user)
    print(f"[DEBUG REGISTER] User created: id={user.id}, email={user.email}, is_onboarded={user.is_onboarded}")

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = security.create_access_token(
        user.id, expires_delta=access_token_expires
    )
    print(f"[DEBUG REGISTER] Token created successfully")
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "is_onboarded": user.is_onboarded,
        "full_name": user.full_name,
    }

@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)):
    print(f"[DEBUG LOGIN] Attempting login: username={form_data.username}")
    result = await db.execute(select(User).filter(User.email == form_data.username))
    user = result.scalars().first()
    
    if not user:
        print(f"[DEBUG LOGIN] No user found with email: {form_data.username}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    print(f"[DEBUG LOGIN] User found: id={user.id}, email={user.email}")
    password_valid = security.verify_password(form_data.password, user.hashed_password)
    print(f"[DEBUG LOGIN] Password verification result: {password_valid}")
    
    if not password_valid:
        print(f"[DEBUG LOGIN] Password mismatch for user: {user.email}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = security.create_access_token(
        user.id, expires_delta=access_token_expires
    )
    print(f"[DEBUG LOGIN] Login successful for user: {user.email}, is_onboarded={user.is_onboarded}")
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "is_onboarded": user.is_onboarded,
        "full_name": user.full_name,
    }

