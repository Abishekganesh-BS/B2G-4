from .retrieval import RetrievalService

class SynthesisApp:
    def __init__(self):
        self.retriever = RetrievalService()

    async def generate_recommendation(self, user_context: str) -> str:
        # 1. Retrieve context
        docs = await self.retriever.search_clinical_guidelines(user_context)
        context_str = "\n".join([d['content'] for d in docs])
        
        # 2. Synthesize (Mock LLM Call)
        # prompt = f"Context: {context_str}\nUser: {user_context}\nAnswer:"
        # response = llm.predict(prompt)
        
        return f"Based on your data and clinical guidelines ({context_str}), we recommend monitoring your glucose levels closely."
