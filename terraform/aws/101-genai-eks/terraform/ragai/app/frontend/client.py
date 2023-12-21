import requests
from streamlit.runtime.uploaded_file_manager import UploadedFile
import os
import logging
import coloredlogs

coloredlogs.install(fmt='%(asctime)s %(levelname)s %(message)s', datefmt='%H:%M:%S', level='INFO')
logging.basicConfig(level=logging.INFO) 
logger = logging.getLogger(__name__)

SERVER_URL = os.environ.get('BACKEND_URL')
#SERVER_URL = "http://fastapi_server:8082"

def get_fastapi_status(server_url: str = SERVER_URL):
    """Access FastAPI /docs endpoint to check if server is running"""
    try:
        logging.info(server_url)  
        response = requests.get(f"{server_url}/docs")
        logging.info(response)  
        if response.status_code == 200:
            return True
    except requests.exceptions.RequestException:
        return False
    
def post_store_pdfs(pdf_files: list[UploadedFile], server_url: str = SERVER_URL):
    """Send POST request to FastAPI /store_pdfs endpoint"""
    files = [("pdf_files", f) for f in pdf_files]
    response = requests.post(f"{SERVER_URL}/store_pdfs", files=files)
    return response

def get_all_documents_file_name():
    """Send GET request to FastAPI /documents endpoint"""
    response = requests.get(f"{SERVER_URL}/documents")
    return response

def get_rag_summary(
    rag_query: str,
    retrieve_top_k: int,
    temperature: float,
    max_tokens: int,
    retrieve_top_p: float,
    server_url: str = SERVER_URL,
):
    """Send GET request to FastAPI /rag_summary endpoint"""
    payload = dict(
        rag_query=rag_query, 
        retrieve_top_k=retrieve_top_k,
        temperature=temperature,
        max_tokens=max_tokens,
        retrieve_top_p=retrieve_top_p
    )
    response = requests.get(f"{SERVER_URL}/rag_summary", data=payload)
    return response
