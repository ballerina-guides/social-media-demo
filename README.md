# Ballerina Social Media Service

The sample is based on a simple API written for a social-media site which has users and associated posts. Following is the high level component diagram.

<img src="diagram.png" alt="drawing" width='500'/>

Following are the features used for the implementation

1. Configuring verbs and URLs
2. Error handlers for sending customized error messages
3. Adding constraints/validations
4. OpenAPI specification for Generating API docs
5. Accessing database
6. Configurability
7. HTTP client 
8. Resiliency - Retry
9. Docker image generation
10. Tracing (Couldn’t get it to work with Spring boot Feign client)

# Setting up each environment

You can use the below docker compose commands.
1. docker compose -f ballerina-docker-compose-db.yml up
2. docker compose -f ballerina-docker-compose.yml up

# Try out
- To send request open `ballerina-social-media.http` file using VS Code with `REST Client` extension
- Jaeger URL - http://localhost:16686/search
