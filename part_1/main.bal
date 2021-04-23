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

public function main() {
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
}
