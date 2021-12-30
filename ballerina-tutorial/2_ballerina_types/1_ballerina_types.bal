import ballerina/udp;
import ballerina/http;
import ballerina/io;

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

// declaring a simple udp-service with service-object pattern
var simleUdpService = service object {
    remote function onDatagram(udp:Datagram dg) {
        io:println("Bytes received: ", dg.data.length());
    }
};
// declaring the udp-listener with required params
//
// listener udp:Listener simpleListener = new (9090);
//

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

// declaring a simple-http-service with resource method
// resource method has two parts 
// 1. accessor -> eg: get
// 2. resource name -> eg: hello
var simpleHttpService = service object {
    // here param `name` is a query param
    // http://localhost:8080/hello?name=ayesh
    resource function get hello (string name) returns string {
        return string`Hello ${name}!`;
    }

    // here param `name` is a path variable
    // http://localhost:8080/greeting/ayesh
    resource function get greeting/[string name] () returns string {
        return string`Hello ${name}!`; 
    }

    // http://localhost:8080/
    resource function get . (http:Caller caller, http:Request request) {
        var response = caller->respond("Hello World..!");
        if (response is error) {
            io:println("Error occurred while responding to the request ", response.message());
        }
    }
};
// listener http:Listener simpleHttpListener = new (8080);

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

// username and password could be provided as configurations in a `toml` file
// configuration variable type should be a subtype of `anydata`
configurable string username = ?;
configurable string password = ?;

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

// open records could have additional fields added to it
// open record is equal to `map<anydata>`
//
// MetaInfo info = {
//      timeStamp: "1234241342",
//      userId: "user1"   
// };
//
// following is valid

// map<anydata> simpleInfo = info;
//
type MetaInfo record {
    string timeStamp;
    string userId;
};

// closed record could not have additional fields added to it
type Coord record {|
    float xPoint;
    float yPoint;
|};
Coord simpleCord = { xPoint: 0.0, yPoint: 0.0 };

// closed records could control the openness as well
// following record is open to only string fields
type Headers record {|
    string 'from;
    string to;
    string...;
|};
Headers headers = {
    'from: "ayesh",
    to: "janith",
    "user": "user1"
};

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

// `json` is a union of `()|boolean|int|float|decimal|string|json[]|map<json>` 
//
type ApiRequest record {|
    string requestId;
    string param1;
    int param2;
|};

type ApiResponse record {|
    string requestId;
    string param1;
    int param2;
|};

type SimpleType record {
    string field1;
    int field2;
};

// writing simple calculator sevice using ballerina-http 
type Args record {|
    decimal x;
    decimal y;
|};

service /calc on new http:Listener(9090) {
    resource function post add (@http:Payload Args args) returns decimal {
        return args.x + args.y;
    }
}
