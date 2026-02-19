class MentalHealthService:
    @staticmethod
    def analyze_sentiment(text: str) -> str:
        # Stub for sentiment analysis
        # In real app: use NLTK or LLM
        if "sad" in text.lower() or "anxious" in text.lower():
            return "monitor"
        return "stable"

    @staticmethod
    def get_digital_detox_recommendation(stress_level: int) -> bool:
        return stress_level > 8
