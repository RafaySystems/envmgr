import client
import streamlit as st

# def show_pdf(base64_pdf: str) -> str:
#     """Show a base64 encoded PDF in the browser using an HTML tag"""
#     return f'<embed src="data:application/pdf;base64,{base64_pdf}" width=100% height=800 type="application/pdf">'


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


def retrieval_form_container() -> None:
    """Container to enter RAG query and sent /rag_summary GET request"""
    left, right = st.columns(2)
    with left:
        form = st.form(key="retrieval_query")
        rag_query = form.text_area(
            "Retrieval Query", value="What are AI startups?"
        )
        

    with right:
        st.write("Hybrid Search Parameters")
        retrieve_top_k = st.number_input(
            "Top K", value=3, help="The number of chunks to consider for response"
        )
        temperature = st.slider(
            "Temperature",
            min_value=0.0,
            max_value=1.0,
            value=0.5,
            help="0: Keyword. 1: Temperature.\n Refer (https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-jurassic2.html)",
        )
        max_tokens = st.slider(
            "Max Tokens",
            min_value=0,
            max_value=8191,
            value=200,
            help="0: Keyword. 1: Max Tokens.\nRefer (https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-jurassic2.html)",
        )

        retrieve_top_p = st.slider(
            "Top P",
            min_value=0.0,
            max_value=1.0,
            value=0.5,
            help="0: Keyword. 1: Top P.\nRefer (https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-jurassic2.html)",
        )
        
    if form.form_submit_button("Search"):
        with st.status("Running"):
            response = client.get_rag_summary(rag_query, int(retrieve_top_k), temperature, int(max_tokens),retrieve_top_p )
        st.session_state["history"].append(dict(query=rag_query, response=response.json()))


def history_display_container(history):
    if len(history) > 1:
        st.header("History")
        max_idx = len(history) - 1
        history_idx = st.slider("History", 0, max_idx, value=max_idx, label_visibility="collapsed")
        entry = history[history_idx]
    else:
        entry = history[0]

    st.subheader("Query")
    st.write(entry["query"])

    st.subheader("Response")
    st.write(entry["response"]["output_text"])

    with st.expander("Sources"):
        st.write(entry["response"]["input_documents"])


def app() -> None:
    """Streamlit entrypoint for PDF Summarize frontend"""
    # config
    st.set_page_config(
        page_title="📤 retrieval",
        page_icon="📚",
        layout="centered",
        menu_items={"Get help": None, "Report a bug": None},
    )
    add_logo()

    st.title("📤 Retrieval")

    retrieval_form_container()

    if history := st.session_state.get("history"):
        history_display_container(history)
    else:
        st.session_state["history"] = list()


if __name__ == "__main__":
    # run as a script to test streamlit app locally
    app()