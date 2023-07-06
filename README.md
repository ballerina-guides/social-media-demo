# [Ballerina] Social Media Service

The sample is based on a simple API written for a social-media site (like twitter) which has users, associated posts and followers. Following is the high level component diagram.

<img src="diagram.jpg" alt="drawing" width='500'/>

Following is the entity relationship diagram.

<img src="er.png" alt="drawing" width='700'/>

Following is the service description.

```ballerina
type SocialMedia service object {
    *http:Service;

    // users resource
    resource function get users() returns User[]|error;
    resource function get users/[int id]() returns User|UserNotFound|error;
    resource function post users(NewUser newUser) returns http:Created|error;
    resource function delete users/[int id]() returns http:NoContent|error;

    // posts resource
    resource function get users/[int id]/posts() returns PostMeta[]|UserNotFound|error;
    resource function post users/[int id]/posts(NewPost newPost) returns http:Created|UserNotFound|PostForbidden|error;
};
```

Following are the features covered by the scenario.

1. Writing REST APIs with verbs, URLs, data binding and status codes
2. Accessing databases
3. Configurability
4. Data transformation with the data mapper
5. HTTP client
6. Resiliency - Retry
7. Writing tests
8. Using connectors - Slack
9. OpenAPI specification, client stubs and central
10. Adding validations
11. Security - OAuth2
12. Error handlers
13. Ballerina concurrency
14. Integrating a message broker

# Setup environment

## With Docker Compose
1. Checkout the code base and move to the root folder
2. Execute `build-docker-images.sh` script to generate the necessary docker images.
3. Execute `docker compose up`

>Note: When trying out feature 11 use port `9098` for the sentiment analysis endpoint.

## Without Docker Compose

### To complete up to feature 4
1. Setup a MySQL database
2. Execute the script `init.sql` in db-setup

### To complete up to feature 7
1. Move to `sentiment-analysis-service` and execute `bal run` to start sentiment analysis service

### To complete up to feature 11
1. Move to `sts-service` and execute `bal run` to start the Security Token Service (STS) service. The URL of the service is `https://localhost:9445/oauth2/token`
2. Move to `sentiment-analysis-service-secured` and execute `bal run` to start secured sentiment analysis service. Following are the OAuth2 details.

   clientId: `FlfJYKBD2c925h4lkycqNZlC2l4a`  
   clientSecret: `PJz0UhTJMrHOo68QQNpvnqAY_3Aa`  
   scope: `admin`  

>Note: When trying out feature 11 use port `9098` for the sentiment analysis endpoint.

### To complete up to feature 14
1. Setup a NATS server

# Try out
- To start the completed setup run `docker compose up -f docker-compose-complete.yml`
- To send request open `social-media-request.http` file using VS Code with `REST Client` extension
