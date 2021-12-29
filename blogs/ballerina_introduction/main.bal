import ballerina/io;
import ballerina/jballerina.java;

// Generates Random UUID using Java UUID API
function createRandomUUID() returns handle = @java:Method {
    name: "randomUUID",
    'class: "java.util.UUID"
} external;

// simple function which takes to integer inputs and calculate the addition
function add(int a, int b) returns int {
    return a + b;
}

// higher-order function which takes two integer inputs and a function which could 
// do a tranformation on two integers and provide an integer result
function apply(int a, int b, function (int, int) returns int fn) returns int {
    return fn(a, b);
}

// usage of smart casting
function printValueType(any value) {
    if (value is int || value is float || value is decimal) {
        io:println("Value is an Number");
    } else if (value is string) {
        io:println(string`Value is a String, and it is ${value.length()} characters long`);
    } else {
        io:println("Could not identify the value type.");
    }
}

type StructureOne record {|
    string param1;
    int param2;
|};

type StructureTwo record {|
    string param1;
    int param2;
|};

// Hello world program for Ballerina starters
public function main() {
    io:println("Hello World!");
    int result = apply(10, 20, add);
    io:println(result);

    // sample for structural typing in ballerina
    StructureOne s1 = {
        param1: "ayesh",
        param2: 10
    };

    StructureTwo s2 = {
        param1: "name",
        param2: 10
    };
    io:println(s1 is StructureTwo);
    io:println(s2 is StructureOne);

    // ballerina null safety
    string name = "ayesh";
    string? keyword = ();

    printValueType(10);
    printValueType("This is a simple string");
}
