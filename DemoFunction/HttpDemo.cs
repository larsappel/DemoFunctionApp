using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace DemoFunction
{
    public class HttpDemo
    {
        private readonly ILogger<HttpDemo> _logger;

        public HttpDemo(ILogger<HttpDemo> logger)
        {
            _logger = logger;
        }

        [Function("HttpDemo")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            return new OkObjectResult("Welcome to Azure Functions!");
        }
    }
}
