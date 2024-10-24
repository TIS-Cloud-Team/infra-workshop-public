- https://www.microsoft.com/en-us/power-platform/blog/power-apps/log-telemetry-for-your-apps-using-azure-application-insights/?msockid=105abbc3cbd56a9129c0af97ca516bd5
- https://medium.com/@kinneko-de/opentelemetry-metrics-meets-azure-c28fc0c7d7d9
- https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-enable?tabs=python
- app insights terraform sample code: https://github.com/Think-Cube/terraform-azure-application-insights
- sample code use "`<Instrumentation key>`":  https://github.com/Azure-Samples/application-insights-aspnet-sample-opentelemetry/tree/master

#### PowerApps

- **PowerApps Limitation** : Currently, PowerApps (Canvas Apps) only supports using the Instrumentation Key for Application Insights integration and does **not** allow specifying the ingestion endpoint.
- **Workarounds** : Implementing middleware services, leveraging Azure Monitor, creating custom connectors, or contacting Microsoft Support are potential strategies to address this limitation
  - Azure Functions or Logic Apps: Implement middleware that receives telemetry data from Power Apps and forwards it to the appropriate Application Insights endpoint.
- https://docs.microsoft.com/en-us/powerapps/maker/canvas-apps/monitor-app
- https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview
- https://powerusers.microsoft.com/t5/Power-Apps-Community/ct-p/PowerApps1
- ingestion endpoint (https://dc.applicationinsights.us/v2/track)
- headers
  - POST
  - Content-Type: application/json
  - x-api-key: Your Application Insights Instrumentation Key
  - ```
    {
        "name": "Microsoft.ApplicationInsights.Event",
        "time": "2024-04-27T00:00:00.000Z",
        "iKey": "YOUR_INSTRUMENTATION_KEY",
        "data": {
            "baseType": "EventData",
            "baseData": {
            "ver": 2,
            "name": "TestEvent",
            "properties": {
                "App": "PowerApps",
                "Environment": "ReviewMode"
            }
            }
        }
        }

    ```

#### powerfx & KQL

* **Azure Monitor and Application Insights Documentation:**
  * [Azure Monitor Logs (KQL) Overview](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview)
  * [Join Operator in KQL](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/joinoperator)
  * [External Data in KQL](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/externaldataoperator)
* **Log Analytics Documentation:**
  * [Create and Manage Tables](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-creating-managing-tables)
  * [Ingest Data into Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-ingest-data)
* **Power Automate Documentation:**
  * [HTTP Actions](https://docs.microsoft.com/en-us/power-automate/connection-http)
  * [Create and Use Flows](https://docs.microsoft.com/en-us/power-automate/getting-started)
* **Security Best Practices:**
  * [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns)
  * [Data Privacy in Azure](https://docs.microsoft.com/en-us/azure/security/fundamentals/privacy)


```powerfx
// Step 1: Define the external table
let UserMapping = externaldata(user_id:string, user_name:string)
[
    @"https://<your_storage_account>.blob.core.windows.net/<container>/<file>.csv"
]
with (
    format = "csv",
    csvfirstrow = true
);

// Step 2: Query traces and join with UserMapping
traces
| extend UserId = tostring(customDimensions.user_id)
| join kind=leftouter (
    UserMapping
) on $left.UserId == $right.user_id
| project timestamp, message, user_id = UserId, user_name, appName = customDimensions.appName
| order by timestamp desc

////////////////////////////////////////////////////////////
// Assuming the external table is defined and accessible
let UserMapping = externaldata(user_id:string, user_name:string)
[
    @"https://<your_external_data_source>"
]
with (
    format = "csv",
    csvfirstrow = true
);

// Join traces with UserMapping
traces
| extend UserId = tostring(customDimensions.user_id)
| join kind=leftouter (
    UserMapping
) on $left.UserId == $right.user_id
| project timestamp, message, user_id = UserId, user_name, appName = customDimensions.appName
| order by timestamp desc

//csv example - user-mapping.csv
user_id,user_name
93eedbc8-22fb-4c48-ba41-ae9e1cef20d3,John Doe
a1b2c3d4-5678-90ab-cdef-1234567890ab,Jane Smith
// Add more mappings as needed

// Private Access: Ideal for security; requires SAS tokens or managed identities
let UserMapping = externaldata(user_id:string, user_name:string)
[
    @"https://<your_storage_account>.blob.core.windows.net/mapping-data/user_mapping.csv?SAS...token"
]
with (
    format = "csv",
    csvfirstrow = true
);

// Assuming 'UserMapping' is the name of your imported table
traces
| extend UserId = tostring(customDimensions.user_id)
| join kind=leftouter (
    UserMapping
) on $left.UserId == $right.user_id
| project timestamp, message, user_id = UserId, user_name, appName = customDimensions.appName
| order by timestamp desc

traces
| extend UserId = tostring(customDimensions.user_id)
| join kind=leftouter (
    UserMapping
) on $left.UserId == $right.user_id
| extend 
    TimestampPST = timestamp - 8h // PST is UTC-8
| project timestamp, TimestampPST, message, user_id = UserId, user_name, appName = customDimensions.appName
| order by TimestampPST desc

// Define the mapping table (assuming it's already imported as 'UserMapping')
traces
| extend UserId = tostring(customDimensions.user_id)
| join kind=leftouter (
    UserMapping
) on $left.UserId == $right.user_id
| extend 
    TimestampPST = timestamp - 8h // Adjust for PST (UTC-8)
| project 
    timestamp, 
    TimestampPST, 
    message, 
    user_id = UserId, 
    user_name, 
    appName = customDimensions.appName
| order by TimestampPST desc


```
