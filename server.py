from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from llama_cpp import Llama
import uvicorn

app = FastAPI(title="Mistral-7B API", 
             description="Text generation API using Mistral-7B")

class GenerationRequest(BaseModel):
    prompt: str
    max_tokens: int = 128
    temperature: float = 0.7

try:
    llm = Llama(
        model_path="./model.gguf",
        n_ctx=1024,
        n_threads=4,
        n_gpu_layers=0
    )
except Exception as e:
    raise RuntimeError(f"Model loading failed: {str(e)}")

@app.get("/health")
async def health_check():
    return {"status": "ready", "model": "Mistral-7B"}

@app.post("/generate")
async def generate_text(request: GenerationRequest):
    try:
        output = llm.create_completion(
            prompt=request.prompt,
            max_tokens=request.max_tokens,
            temperature=request.temperature
        )
        return {"response": output["choices"][0]["text"]}
    except Exception as e:
        raise HTTPException(500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)

