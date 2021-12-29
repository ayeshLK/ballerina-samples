import ballerina/io;
import ballerina/jballerina.java;

class Person {
    private string firstName;
    private string lastName;

    public function init(string firstName, string lastName) {
        self.firstName = firstName;
        self.lastName = lastName;
    }

    public function getFullName() returns string {
        return string `${self.firstName} ${self.lastName}`;
    }
}

var greeter = object {
    function greet(string name) returns string {
        return string `Hello, ${name}!`;
    }
};

// this function is used to convert a `string` into a `int`
function convertToInt(string number) returns int|error {
    // this conversion could have an errorneous result if the provided
    // `string` is not a number
    int|error result = int:fromString(number);
    return result;
}


type  ReturnType typedesc<string|int>;

// isolated function parse(anydata value, ReturnType returnType = <>) 
//             returns returnType = @java:Method {
//     'class: "io.ballerina.sample.Processor"
// } external;

// Retrieves the current System output stream
public function out() returns handle = @java:FieldGet {
    name: "out",
    'class: "java.lang.System"
} external;

// Calls `println` method of the  `PrintStream`
function println(handle receiver, handle message) = @java:Method {
    paramTypes: ["java.lang.String"],
    'class: "java.io.PrintStream"
} external;



public function main() returns error? {
    Person p1 = new("John", "Doe");
    io:println(p1.getFullName());

    io:println(greeter.greet("Kamal"));


    stream<string[], io:Error?> csvStream = check io:fileReadCsvAsStream("sample.csv");
    check csvStream.forEach(function (string[] val) {
        io:println(string `${val[0]} - ${val[1]}`);
    });

    var sysOut = out();
    println(sysOut, java:fromString("Hello, World..!"));
}
