# Step 1: Install the required package
# Run this command in your terminal
# pip install opencensus-ext-azure

from opencensus.ext.azure.log_exporter import AzureLogHandler
import logging

# Step 2: Set up the logger with the Instrumentation Key
instrumentation_key = 'YOUR_INSTRUMENTATION_KEY'
logger = logging.getLogger(__name__)
logger.addHandler(AzureLogHandler(connection_string=f'InstrumentationKey={instrumentation_key}'))
logger.setLevel(logging.INFO)

# Step 3: Log a custom event
logger.info('Custom event: User logged in', extra={'custom_dimensions': {'user_id': '12345'}})

print("Log sent to Azure Application Insights")