# Frontend implementation for Ripplit

## Overview

This is the frontend implementation for Ripplit. It consists of a React application that works with a containerized Ballerina backend.

## Get Started

There are three ways to instantly serve up the frontend application:

1. Serve the application using NodeJS.

```bash
npx serve dist --single --listen 2201
```

- Open the browser and navigate to: [http://localhost:2201](http://localhost:2201)

2. Serve the application using Python.

```bash
python -m http.server 2201 --directory dist
```

- Open the browser and navigate to: [http://localhost:2201](http://localhost:2201)

> Note: URL rewriting is not supported when serving the production build using python. (contents of ErrorPage.jsx will not render for invalid URLs)

3. Serve the application using Docker.

- Navigate to the `social-media-demo` directory.

- Run the following command.

```bash
docker compose up
```

- Open the browser and navigate to: [http://localhost:3001](http://localhost:3001)

## Running the Application in Development Mode

### Prerequisites

Install the following software.

- [Node.js version: v20.12.0](https://nodejs.org/en/blog/release/v20.12.0)
- [npm (version 10.5.0 or later)](https://www.npmjs.com/package/npm)

### Steps

1. Install the required project dependencies by running the following command.

```bash
npm install
```

2. Start the application.

```bash'
npm run dev
```

3. Open the browser and navigate to [http://localhost:5173](http://localhost:5173).

4. For deploying the application, create a production build by running the following command.

```bash
npm run build
```
