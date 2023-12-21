import base64
from contextlib import asynccontextmanager
from dataclasses import dataclass

import fastapi
import pydantic

import os
import fastapi
from fastapi.responses import JSONResponse
from langchain.document_loaders import UnstructuredFileLoader, PyPDFLoader
from langchain.vectorstores import Qdrant
from langchain.embeddings import OpenAIEmbeddings
import boto3
from fastapi.responses import JSONResponse
from langchain.vectorstores import Qdrant
from langchain.embeddings import OpenAIEmbeddings
from qdrant_client import QdrantClient
from langchain.llms.bedrock import Bedrock
from langchain.chains.question_answering import load_qa_chain
import logging
import coloredlogs
from prometheus_fastapi_instrumentator import Instrumentator
from utils import secret

coloredlogs.install(fmt='%(asctime)s %(levelname)s %(message)s', datefmt='%H:%M:%S', level='INFO')
logging.basicConfig(level=logging.INFO) 
logger = logging.getLogger(__name__)


qdrant_url = os.environ.get('QDRANT_URL')
open_ai_secret_prefix = os.environ.get('OPEN_AI_SECRET_PREFIX')


@dataclass
class GlobalContext:
    vector_db_url: str
    collection_name: str

@asynccontextmanager
async def lifespan(app: fastapi.FastAPI) -> None:
    """Startup and shutdown logic of the FastAPI app
    Above yield statement is at startup and below at shutdown
    """
    logger.info(qdrant_url)
    global global_context
    global_context = GlobalContext(vector_db_url=qdrant_url,collection_name="rag")

    yield
                                   

# instantiate FastAPI app
app = fastapi.FastAPI(
    title="Retrieval Augmented Generation with Amazon Bedrock",
    lifespan=lifespan,
)

Instrumentator().instrument(app).expose(app)




class SummaryResponse(pydantic.BaseModel):
    summary: str
    chunks: list[dict]
 


@app.post("/store_pdfs", tags=["Ingestion"])
async def store_pdfs(pdf_files: list[fastapi.UploadFile]) -> JSONResponse:
    """For each PDF file, read as text, create chunks, and embed them using OpenAI API\n
    Store chunks with embeddings in Qdrant.
    """   
    folder_path = f'./'
    os.makedirs(folder_path, exist_ok=True)
    for file in pdf_files:
        file_path = os.path.join(folder_path, file.filename)
        try:
            with open(file_path, 'wb') as f:
                while contents := file.file.read(1024 * 1024):
                  f.write(contents)
        except Exception:
            return JSONResponse(content=dict(message="There was an error uploading the file(s)"))
        finally:
            file.file.close()
        import mimetypes
        mime_type = mimetypes.guess_type(file_path)[0]
        if mime_type == 'application/pdf':
           loader = PyPDFLoader(file_path)
           docs = loader.load_and_split() 
        else:
           loader = UnstructuredFileLoader(file_path)
           docs = loader.load()
        open_ai_key = secret.get_secret(open_ai_secret_prefix)
        embeddings = OpenAIEmbeddings(openai_api_key=open_ai_key)
        qdrant = Qdrant.from_documents(docs,embeddings,url=global_context.vector_db_url, collection_name=global_context.collection_name, prefer_grpc=True, api_key="")
        os.remove(file_path) # Delete downloaded file
    return JSONResponse(content=dict(stored_pdfs=True,collection_name=qdrant.collection_name))

@app.get("/rag_summary", tags=["Retrieval"])
async def store(rag_query: str = fastapi.Form(...),
    retrieve_top_k: int = fastapi.Form(...),          
    temperature: float = fastapi.Form(...),
    max_tokens: int = fastapi.Form(...),
    retrieve_top_p: float = fastapi.Form(...)) -> JSONResponse:
    client = QdrantClient(url=global_context.vector_db_url, prefer_grpc=True, api_key="")
    open_ai_key = secret.get_secret(open_ai_secret_prefix)
    embeddings = OpenAIEmbeddings(openai_api_key=open_ai_key)
    bedrock_client = boto3.client("bedrock-runtime")
    bedrock_llm = Bedrock(
        model_id="ai21.j2-ultra-v1",
        client=bedrock_client,
        model_kwargs={'temperature': temperature, 'maxTokens': max_tokens, 'topP':retrieve_top_p}
        )
    qdrant = Qdrant(client=client, collection_name=global_context.collection_name, embeddings=embeddings)
    search_results = qdrant.similarity_search(rag_query, k=retrieve_top_k)
    chain = load_qa_chain(bedrock_llm,chain_type="stuff")
    results = chain({"input_documents": search_results, "question": rag_query}, return_only_outputs=False)
    response = {
        'output_text': results["output_text"],
        'question': results["question"],
        'input_documents': []
    }
    for doc in results["input_documents"]:
        input_document = {
            'page_content':doc.page_content,
            'metadata':{
                'page': doc.metadata["page"],
                'source': doc.metadata["source"]
            }
        }
        response['input_documents'].append(input_document)
       
    return JSONResponse(content=response)


@app.get("/documents", tags=["Retrieval"])
async def documents() -> JSONResponse:
    return JSONResponse(content=dict(documents="True"))



if __name__ == "__main__":
    # run as a script to test server locally
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8082)



