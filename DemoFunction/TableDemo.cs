using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Azure.Data.Tables;
using Azure;

namespace DemoFunction
{
    public class TableDemo
    {
        private readonly ILogger<TableDemo> _logger;

        public TableDemo(ILogger<TableDemo> logger)
        {
            _logger = logger;
        }

        [Function("TableDemo")]
        public async Task<IActionResult> RunAsync([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            // Read the request body
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic? data = JsonConvert.DeserializeObject(requestBody);

            // Return a welcome message if no data is provided in post request
            if (data == null)
            {
                return new OkObjectResult("Welcome to Azure Functions! /TableDemo");
            }

            // Validate input in post request
            if (data?.name == null || data?.email == null)
            {
                return new BadRequestObjectResult("Please provide both 'name' and 'email' in the request body. ");
                    // Example of a valid post request body:
                    // {
                    //     "name": "Demo",
                    //     "email": "demo@demo.com"
                    // }
            }

            // Connect to Table Storage in the same storage account as the function
            string storageConnectionString = Environment.GetEnvironmentVariable("AzureWebJobsStorage");
            
            // Create a new TableClient
            var tableClient = new TableClient(storageConnectionString, "DemoTable");
            
            // Create the table if it doesn't exist
            await tableClient.CreateIfNotExistsAsync();

            // Create a new table entity
            var entity = new DemoEntity(data.name.ToString(), data.email.ToString());
            await tableClient.AddEntityAsync(entity);

            return new OkObjectResult("Welcome to Azure Functions!");
        }

        // Function to get all table entries
        [Function("GetAllEntries")]
        public async Task<IActionResult> GetAllEntriesAsync([HttpTrigger(AuthorizationLevel.Function, "get")] HttpRequest req)
        {
            _logger.LogInformation("Retrieving all entries from the Azure Table.");

            // Connect to Table Storage in the same storage account as the function
            string? storageConnectionString = Environment.GetEnvironmentVariable("AzureWebJobsStorage");
            
            // Create a new TableClient
            var tableClient = new TableClient(storageConnectionString, "DemoTable");
            
            // Query all entities in the table
            List<DemoEntity> entities = new List<DemoEntity>();
            await foreach (var entity in tableClient.QueryAsync<DemoEntity>())
            {
                entities.Add(entity);
            }

            // Return the list of entities as JSON
            return new OkObjectResult(entities);
        }

        // Define a class to represent the table entity
        public class DemoEntity : ITableEntity
        {
            // ITableEntity implementation
            public string PartitionKey { get; set; }
            public string RowKey { get; set; }
            public DateTimeOffset? Timestamp { get; set; }
            public ETag ETag { get; set; } = ETag.All;

            // Custom properties
            public string Email { get; set; }
            public string Name { get; set; }

            // Constructor
            public DemoEntity(string name, string email)
            {
                PartitionKey = "Demo";
                RowKey = Guid.NewGuid().ToString();

                Email = email;
                Name = name;
            }

            // Parameterless constructor (needed for querying)
            public DemoEntity()
            {
                PartitionKey = "Demo";
                RowKey = Guid.NewGuid().ToString();

                Email = string.Empty;
                Name = string.Empty;
            }
        }

    }
}
