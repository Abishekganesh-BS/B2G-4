class PediatricService:
    @staticmethod
    def check_growth(age_months: int, weight_kg: float, gender: str) -> str:
        # Simplified WHO standards check
        # Example for 6 months
        if age_months == 6:
            min_weight = 6.4 if gender == 'male' else 5.8
            if weight_kg < min_weight:
                return "Below expected range"
        return "Normal growth"
