class LifestyleService:
    @staticmethod
    def generate_plan(trimester: int, complications: list[str]) -> dict:
        plan = {
            "diet": ["Whole grains", "Lean protein"],
            "activity": ["Walking 30 min"]
        }
        
        if "GDM" in complications:
            plan["diet"] = ["Low GI Index foods", "Complex carbs only"]
            
        if trimester == 3:
            plan["activity"] = ["Gentle stretching", "Pelvic floor exercises"]
            
        return plan
