# Package Overview

The package offers client functionality to establish connections with the sentiment API endpoint and obtain the corresponding analysis results.

## Sentiment analysis Client

Sentiment analysis client offers the client functionalities to establish connections with the sentiment API endpoint and retrieve the relevant analysis 
results for a given content.

### Create sentiment analysis client

An `sentiment.analysis:Client` can be created as follows.
```ballerina
import balguides/sentiment.analysis;

public function main() returns error? {
    analysis:Client sentimentClient = check new ();
}
```
