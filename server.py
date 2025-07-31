from fastapi import FastAPI
from llama_cpp import Llama
import uvicorn

app = FastAPI()
llm = Llama(
    model_path="./model.gguf",
    n_ctx=2048,
    n_threads=8,
    n_gpu_layers=0
)

@app.post("/generate")
async def generate_text(prompt: str, max_tokens: int = 128):
    output = llm.create_completion(
        prompt=prompt,
        max_tokens=max_tokens,
        temperature=0.7
    )
    return {"response": output["choices"]["text"]}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
