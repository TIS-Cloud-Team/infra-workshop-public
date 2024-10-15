import logging
import os
import json
import azure.functions as func
from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient

def main(event: func.EventGridEvent):
    logging.info('Python EventGrid trigger processed an event: %s', event.get_json())

    resource_id = event.subject
    user_email = event.get_json().get('data', {}).get('claims', {}).get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress')

    if not user_email:
        logging.error('User email not found in event data')
        return

    credential = DefaultAzureCredential()
    client = ResourceManagementClient(credential, os.environ['AZURE_SUBSCRIPTION_ID'])

    resource = client.resources.get_by_id(resource_id, api_version='2021-04-01')
    tags = resource.tags or {}
    tags['owner'] = user_email

    client.resources.update_by_id(resource_id, api_version='2021-04-01', parameters={'tags': tags})