# [Ballerina] Social Media Service

The sample is based on a simple API written for a social-media site (like twitter) which has users, associated posts and followers. Following is the high level component diagram.

<img src="diagram.png" alt="drawing" width='500'/>

Following is the entity relationship diagram.

<img src="er.png" alt="drawing" width='700'/>

Following are the features covered by the scenario.

1. Writing REST APIs with verbs, URLs, databinging and statuscodes
2. Accessing database
3. Configurability
4. Data transformation with datamapper
5. HTTP client
6. Using connectors - twillio
7. OpenAPI specification, client stubs and central
8. Adding constraints/validations
9. Security - OAuth2
10. Error handlers
11. Resiliency - Retry
12. Observability - Tracing
13. Docker image generation

# Setup each environment

You can use the below docker compose commands.
1. docker compose -f ballerina-docker-compose-db.yml up
2. docker compose -f ballerina-docker-compose.yml up

# Try out
- To send request open `ballerina-social-media.http` file using VS Code with `REST Client` extension
- Jaeger URL - http://localhost:16686/search
