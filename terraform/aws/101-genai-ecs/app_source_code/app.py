import chainlit as cl
from langchain.chains import ConversationChain, LLMChain
from langchain.llms import Bedrock
from langchain.memory import ConversationTokenBufferMemory
from langchain.prompts import PromptTemplate

template = """
You are a world class chat bot. You shall chat with the user and answer their questions.

Question: {question}"""


@cl.on_chat_start
def main():
    # Instantiate the chain for that user session
    prompt = PromptTemplate(template=template, input_variables=["question"])

    llm = Bedrock(model_id="amazon.titan-text-express-v1")
    memory = ConversationTokenBufferMemory(llm=llm, max_token_limit=3500)

    conv_chain = ConversationChain(llm=llm, memory=memory, verbose=True)

    # Store the chain in the user session
    cl.user_session.set("conv_chain", conv_chain)


@cl.on_message
async def main(message: cl.Message):
    # Retrieve the chain from the user session
    conv_chain = cl.user_session.get("conv_chain")  # type: LLMChain

    # Call the chain asynchronously
    res = await conv_chain.acall(message.content, callbacks=[cl.AsyncLangchainCallbackHandler()])
    print(res)
    # Do any post processing here

    # "res" is a Dict. For this chain, we get the response by reading the "text" key.
    # This varies from chain to chain, you should check which key to read.
    await cl.Message(content=res["response"]).send()
