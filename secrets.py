import prefect
from prefect import Flow, task
from azure.storage.blob import BlobServiceClient
from prefect.client import Secret

s = Secret('azure_credential').get()

@task
def create_container(container_name, connect_str):
    """ Creates a container on Azure """
    logger = prefect.context.get("logger")
    try:
        blob_service_client = BlobServiceClient.from_connection_string(connect_str)
        blob_service_client.create_container(container_name)
        logger.info(f"Created new container named {container_name}")
    except:
        logger.warning("Unable to create new container.")

with Flow("secrets-example") as flow:
    create_container(container_name = 'my-new-container', connect_str = s)

flow.register(project_name="Hello Anaconda Enterprise")