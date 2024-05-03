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
    resource function get posts() returns PostWithMeta[]|error;
    resource function get users/[int id]/posts() returns PostMeta[]|UserNotFound|error;
    resource function post users/[int id]/posts(NewPost newPost) returns http:Created|UserNotFound|PostForbidden|error;
};
```

Following are the features covered by the scenario.

- Writing REST APIs with verbs, URLs, data
- binding and status codes
- Accessing databases
- Configurability
- Debugging Ballerina programs
- HTTP client
- Resiliency - Retry
- OpenAPI specification, client stubs and central
- Handling errors
- Writing a simple testcase
- HTTP client
- Deploying in docker and kubernetes
- Generating GraalVM images

# Setup environment

## With Docker Compose

1. Checkout the code base and move to the root folder
2. Execute `build-docker-images.sh` script to generate the necessary docker images.
3. Execute `docker compose up`

## Without Docker Compose

1. Setup a MySQL database
2. Execute the script `init.sql` in db-setup

# Try out

- To start the completed setup run `docker compose up -f docker-compose-complete.yml`
- To send request open `social-media-request.http` file using VS Code with `REST Client` extension
- To open the frontend type `http://localhost:3001`in the browser
