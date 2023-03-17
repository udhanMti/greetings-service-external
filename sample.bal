import ballerina/http;
import ballerina/io;

service / on new http:Listener(8090) {
    resource function get .(
        string name,
        @http:Header string apiKey,
        @http:Header string internalHost
    ) returns json|error {
        return sayGreetings(name, apiKey, internalHost);
    }
}

public function sayGreetings(string name, string apiKey, string host) returns json|error {
    // Creates a new client with the Basic REST service URL.
    http:Client greetingClient = check new (string `https://${host}`);
        // {
        //     secureSocket: { 
        //         enable: true
        //     }
        // }
        

    // Sends a `GET` request to the "/albums" resource.
    // The verb is not mandatory as it is default to "GET".
    map<string> additionalHeaders = {
        "API-Key" : apiKey
    };
    json|error response = greetingClient->get(string `rbkt/greeting-service-internal/1.0.0?name=${name}`, additionalHeaders);
    if response is error {
        io:println("GET request error:" + response.detail().toString());
    } else {
        io:println("GET request:" + response.toJsonString());
    }

    return response;
}
