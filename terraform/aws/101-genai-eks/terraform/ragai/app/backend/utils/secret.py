import boto3
import logging
import coloredlogs

coloredlogs.install(fmt='%(asctime)s %(levelname)s %(message)s', datefmt='%H:%M:%S', level='INFO')
logging.basicConfig(level=logging.INFO) 
logger = logging.getLogger(__name__)

def get_secret(secret_prefix):
    client = boto3.client('secretsmanager')
    secret_arn = locate_secret_arn(secret_prefix, client)
    secret_value = client.get_secret_value(SecretId=secret_arn)
    return secret_value['SecretString']
    
    
def locate_secret_arn(secret_tag_value, client):
    logger.info(secret_tag_value)
    response = client.list_secrets(
        Filters=[
            {
                'Key': 'tag-key',
                'Values': ['Name']
            },
            {
                'Key': 'tag-value',
                'Values': [secret_tag_value]
            }
        ]
    )
    return response['SecretList'][0]['ARN']