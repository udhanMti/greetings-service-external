import ballerina/http;
import ballerina/io;

service / on new http:Listener(8090) {
    resource function get .(
        string name,
        @http:Header string apiKey
    ) returns json|error {
        return sayGreetings(name, apiKey);
    }
}

public function sayGreetings(string name, string apiKey) returns json|error {
    // Creates a new client with the Basic REST service URL.
    http:Client greetingClient = check new ("https://abf64c3b-258d-4746-8279-d6c5f63ea558-testenv01-gsqs-internal.dev-us-east-azure.internal.choreo-dv.choreoapis.dev", 
        {
            secureSocket: { 
                enable: true
            }
        });

    // Sends a `GET` request to the "/albums" resource.
    // The verb is not mandatory as it is default to "GET".
    map<string> additionalHeaders = {
        "API-Key" : apiKey
    };
    json|error response = greetingClient->get(string `/gsqs/greetingsserviceinternal/1.0.0?name=${name}`, additionalHeaders);
    if response is error {
        io:println("GET request error:" + response.detail().toString());
    } else {
        io:println("GET request:" + response.toJsonString());
    }

    return response;
}
