from fastapi import UploadFile
import pypdf
import io

class IngestionService:
    @staticmethod
    async def process_pdf(file: UploadFile) -> str:
        content = ""
        pdf_reader = pypdf.PdfReader(io.BytesIO(await file.read()))
        for page in pdf_reader.pages:
            content += page.extract_text() + "\n"
        return content

    @staticmethod
    def process_metric(data: dict):
        # Validation logic here
        return data
