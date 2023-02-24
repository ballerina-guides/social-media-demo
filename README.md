# [Ballerina] Social Media Service

The sample is based on a simple API written for a social-media site (like twitter) which has users, associated posts and followers. Following is the high level component diagram.

<img src="diagram.png" alt="drawing" width='500'/>

Following is the entity relationship diagram.

<img src="er.png" alt="drawing" width='700'/>

Following is the service description.

```ballerina
type SocialMedia service object {
    *http:Service;

    // users resource
    resource function get users() returns User[]|error;
    resource function get users/[int id]() returns User|UserNotFound|error;
    resource function post users(@http:Payload NewUser newUser) returns http:Created|error;
    resource function delete users/[int id]() returns http:NoContent|error;

    // posts resource
    resource function get users/[int id]/posts() returns PostMeta[]|UserNotFound|error;
    resource function post users/[int id]/posts(@http:Payload NewPost newPost) returns http:Created|UserNotFound|PostForbidden|error;
};
```

Following are the features covered by the scenario.

1. Writing REST APIs with verbs, URLs, databinging and statuscodes
2. Accessing database
3. Configurability
4. Data transformation with datamapper
5. HTTP client
6. Writing tests
7. Using connectors - twillio
8. OpenAPI specification, client stubs and central
9. Adding constraints/validations
10. Security - OAuth2
11. Error handlers
12. Resiliency - Retry
13. Observability - Tracing
14. Docker image generation

# Setup each environment

You can use the below docker compose commands.
1. docker compose -f docker-compose-db.yml up
2. docker compose -f docker-compose.yml up

# Try out
- To send request open `social-media-request.http` file using VS Code with `REST Client` extension
- Jaeger URL - http://localhost:16686/search
