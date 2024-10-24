# Step 1: Install the required package
# Run this command in your terminal
# pip install azure-monitor-opentelemetry

# https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-python-opencensus-migrate
# https://github.com/microsoft/opentelemetry-azure-monitor-python
# https://docs.microsoft.com/azure/azure-monitor/app/create-new-resource

from azure_monitor import AzureMonitorSpanExporter
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchExportSpanProcessor

trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

# SpanExporter receives the spans and send them to the target location
# InstrumentationKey=b5093faa-4116-433a-ac0e-107323ef7837;IngestionEndpoint=https://westus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://westus.livediagnostics.monitor.azure.com/;ApplicationId=29c5b501-1850-4b4b-b8b4-2cbf4c28dda1
exporter = AzureMonitorSpanExporter(
    connection_string='InstrumentationKey=b5093faa-4116-433a-ac0e-107323ef7837',
)

span_processor = BatchExportSpanProcessor(exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

with tracer.start_as_current_span('hello'):
    print('Hello World!')

## logger.error('Custom event from python app - jlin : User logged in', extra={'custom_dimensions': {'user_id': '12345'}})

print("Log sent to Azure Monitor Application Insights")