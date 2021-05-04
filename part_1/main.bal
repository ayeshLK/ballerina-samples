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

// functions are first class citizens
var isOdd = function (int i) returns boolean => i % 2 != 0;
// following defines `IntFilter` function type
type IntFilter function (int) returns boolean;
// creates a instance of `IntFilter` type
IntFilter evenFilter = function (int i) returns boolean => i % 2 == 0;

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

public function main() returns error? {
    LinkedList n1 = {
        value: "node 2",
        next: ()
    };
    LinkedList n2 = {
        value: "node 2",
        next: ()
    };
    LinkedList n3 = {
        value: "node 3",
        next: ()
    };
    n1.next = n2;
    n2.next = n3;

    io:println("Length of the LinkedList is ", len(n1));

    MapArray mapArray = [
        {
            "k1": "v1"
        },
        {
            "k2": "v2"
        }
    ];

    // inline record type definition
    record {|
        int x;
        int y;
    |} point = { x:0, y:0 };

    Coord c1 = { x:0, y:0 };

    Name name1 = "Ayesh Almeida";
    io:println(toString(name1));
    Name name2 = {
        firstName: "Shelani",
        lastName: "De Silva"
    };
    io:println(toString(name2));

    // igonoring return values without errors
    _ = printAndReturnValue(10); 
    // igonoring return value with errors
    checkpanic printCodePointSummation("ayesh");

    // arrays n maps are `covariant` - sub-type collectins can be held by super-type collection
    int[] iv = [1, 2, 3];
    any[] av = iv;

    // av[0] = "str"; is incorrect / this would result in runtime error

    map<int> ivm = {
        a: 1,
        b: 2
    };
    map<any> avm = ivm;

    Counter counter1 = new;
    io:println("Current counter value ", counter1.retrieveAndIncrementCounter());
    io:println("Next counter value ", counter1.retrieveAndIncrementCounter());

    string nameOfTheDay = getDayOfWeek(1);
    io:println(string`First day of the Week is ${nameOfTheDay}`);

    int[] nums = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    int[] evenNumbers = nums.filter(evenFilter);
    io:println("Available even numbers are...");
    foreach var i in evenNumbers {
        io:print(i.toString(), " ");
    }

    // async function calls 
    future<int> f1 = start GCD(137, 21);
    future<int> f2 = start GCD(4736, 82);

    // waiting for async calls could be done in two ways
    // 1. wait for individual calls
    //
    // int gcd1 = check wait gdc1F;
    // int gcd2 = check wait gdc2F;

    // 2. wait for both
    record {int x1;  int x2;} gcdCalc = wait { x1: f1, x2: f2 };
    int gcd1 = gcdCalc.x1;
    int gcd2 = gcdCalc.x2;
    io:println(string`GCD Calcl [137, 21] = ${gcd1}`);
    io:println(string`GCD Calcl [4736, 82] = ${gcd2}`);
}
