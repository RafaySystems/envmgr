import client
import streamlit as st


def add_logo():
    st.markdown(
        """
        <style>
            [data-testid="stSidebarNav"] {
                background-image: url(https://rafay-image.s3-us-west-2.amazonaws.com/rafay-logo-transparent.png);
                background-repeat: no-repeat;
                background-size: 70%;
                background-position: 20px 20px;
                background-color: #ffffff;
            }
        </style>
        """,
        unsafe_allow_html=True,
    )
def app() -> None:
    """Streamlit entrypoint for PDF Summarize frontend"""
    # config
    st.set_page_config(
        page_title="Retrieval Augmented Generation",
        page_icon="📚",
        layout="centered",
        menu_items={"Get help": None, "Report a bug": None},
    )
    add_logo()

    st.title("📚 Retrieval Augmented Generation")

    if client.get_fastapi_status() is False:
        st.warning("FastAPI is not ready. Make sure your backend is running")
        st.stop()  # exit application after displaying warning if FastAPI is not available

    st.header("Information")
    st.markdown(
        """
    This application allows you to import arbitrary PDF files and search over them using LLMs. For each file, the text is divided in chunks that are embedded with OpenAI and stored in Qdrant. When you query the system, the most relevant chunks are retrieved and a summary answer is generated using OpenAI embeddings chained to Amazon Bedrock Model.

    The ingestion and retrieval steps are implemented as dataflows are exposed via FastAPI endpoints. The frontend is built with Streamlit and exposes the different functionalities via a simple web UI. Everything is packaged as containers with helm charts.

    """
    )


if __name__ == "__main__":
    # run as a script to test streamlit app locally
    app()