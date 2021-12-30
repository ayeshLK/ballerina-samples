import ballerina/io;

// simple foreach loop using array indexes
function intSum(int[] numbers) returns int {
    int sum = 0;
    foreach int i in 0..< numbers.length() {
        sum += numbers[i];
    }
    return sum;
}

// foreach loop
function floatSum(float[] numbers) returns float {
    float sum = 0.0;
    foreach float i in numbers {
        sum += i;
    }
    return sum;
}

type LinkedList record {
    string value;
    LinkedList? next;
};

// simple while loop
function len(LinkedList 'list) returns int {
    int n = 0;
    LinkedList? currentNode = 'list;
    while (currentNode != ()) {
        n += 1;
        currentNode = currentNode?.next;
    }
    return n;
}

// type definition
type MapArray map<string>[];

// record type definition
type Coord record {
    int x;
    int y;
};

type StructuredName record {|
    string firstName;
    string lastName;
|};

// defining union type
type Name StructuredName|string;

function toString(Name name) returns string {
    if (name is StructuredName) {
        return string`${name.firstName} ${name.lastName}`;
    } else {
        return name;
    }
}


function printAndReturnValue(int x) returns int {
    io:println("Current value is ", x);
    return x;
}

function printCodePointSummation(string message) returns error? {
    int sum = 0;
    int[] codePoints = string:toCodePointInts(message);
    foreach int i in codePoints {
        sum += i;
    }
    io:println("Sum of code points ", sum);
}

public class Counter {
    private int counter = 0;

    public isolated function retrieveAndIncrementCounter() returns int {
        lock {
            int currentValue = self.counter;
            self.counter += 1;
            return currentValue;
        }
    }
}

// match statement internally uses `==` to match the value
function getDayOfWeek(int day) returns string {
    match day {
        1 => {
            return "MONDAY";
        }
        2 => {
            return "TUESDAY";
        }
        3 => {
            return "WEDNESDAY";
        }
        4 => {
            return "THURSDAY";
        }
        5 => {
            return "FRIDAY";
        }
        6 => {
            return "SATURDAY";
        }
        7 => {
            return "SUNDAY";
        }
        _ => {
            panic error("UNIDENTIFIED DAY");
        } 
    }
}

function isEven(int a) returns boolean {
    match (a % 2) {
        0 => {
            return true;
        }
        _ => {
            return false;
        }
    }
}

// functions are first class citizens
var isOdd = function (int i) returns boolean => i % 2 != 0;
// following defines `IntFilter` function type
type IntFilter function (int) returns boolean;
// creates a instance of `IntFilter` type
IntFilter evenFilter = function (int i) returns boolean => i % 2 == 0;

function apply(int a, int b, function (int, int) returns int fun) returns int {
    return fun(a, b);
}

function getIntFilter() returns function (int) returns boolean {
    return function (int i) returns boolean => i % 2 == 0;
}

function findMax(int a, int b) returns int {
    if (a > b) {
    	return a;
    } else {
    	return b;
    }
}

function GCD(int a, int b) returns int {
    int aVal = a;
    int bVal = b;
    while (bVal != 0) {
        int t = bVal;
        bVal = aVal % bVal;
        aVal = t;
    }
    return aVal;
}
