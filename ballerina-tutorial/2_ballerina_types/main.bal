import ballerina/lang.value;
import ballerina/io;

// simple object declaration without classes
var simpleObject = object {
    isolated function greet(string name) returns string {
        return string`Hello, ${name}! Welcome to Ballerina..!`;
    }
};

public function main() returns error? {
    io:println(simpleObject.greet("Ayesh"));

    // dynamically attaching to the listener
    //
    // check simpleListener.attach(simleUdpService);
    // check simpleHttpListener.attach(simpleHttpService);
    //
    // listener could have multiple services attached to different paths

    json j = { "x": 1, "y": 0 };
    string jsonString = j.toJsonString();
    json j2 = check value:fromJsonString(jsonString);
    json j3 = null;

    // working with json directly
    json j4 = {
        x: {
            y: {
                z: "ayesh"
            }
        }
    };
    json v = check j4.x.y.z;
    string value1 = check value:ensureType(v, string);

    // converting json to user-defined types
    json plainRequest = {
        requestId: "req_00001",
        param1: "value1",
        param2: 1
    };
    ApiRequest apiRequest1 = check plainRequest.cloneWithType(ApiRequest);
    // argument type is defaulted from the context
    ApiRequest apiRequest2 = check plainRequest.cloneWithType();

    // converting user-defined type to json (for a closed record)
    ApiResponse apiResponse = {
        requestId: "req_00001",
        param1: "value1",
        param2: 1
    };
    json plainResponse = apiResponse;

    // converting user-defined type to json (for an open record)
    SimpleType type1 = {
        field1: "value1",
        field2: 10
    };
    json plainTypeDesc = type1.toJson();
}
