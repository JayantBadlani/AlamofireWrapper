# AlamofireWrapper

## API Manager using Alamofire

This is a Swift class that encapsulates HTTP requests to an API using Alamofire library. It is designed to work with Codable data structures, making it easy to handle JSON responses.

The class handles basic functionalities such as constructing a request URL, adding headers and authentication tokens, encoding parameters, and parsing JSON responses. It also performs validation on the HTTP status codes.

## Getting Started
To use the API Manager in your project, simply add the ApiManager.swift file to your project directory.

## Usage
The class provides a single function that handles all the necessary steps for an API request. Here's how you can use it:

```ruby
ApiManager.shared.apiCallWith(apiEndPoint: "your_api_endpoint",
                               method: .get,
                               queryParam: nil,
                               param: nil,
                               extraHeaders: nil,
                               typeOf: YourModel.self) { (success, response, msg) in
    if success, let data = response {
        // Handle successful response with your data model
    } else {
        // Handle error with the message
    }
}
```

## You can customize your API call with the following parameters:

apiEndPoint - The endpoint of the API to call.
method - The HTTP method to use for the request (e.g. .get, .post, .put).
queryParam - Optional parameters to include in the URL as a query string.
param - Optional parameters to include in the body of the request.
extraHeaders - Optional HTTP headers to include in the request.
typeOf - The type of the expected response data. This should be a Codable data structure that represents the JSON response from the API.
completion - A closure that will be called when the request completes. The closure returns three parameters: success, response, and msg.

