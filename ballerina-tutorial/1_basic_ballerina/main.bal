import ballerina/io;

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
    // int gcd1 = check wait f1;
    // int gcd2 = check wait f2;

    // 2. wait for both
    record {int|error x1;  int|error x2;} gcdCalc = wait { x1: f1, x2: f2 };
    int gcd1 = check gcdCalc.x1;
    int gcd2 = check gcdCalc.x2;
    io:println(string`GCD Calcl [137, 21] = ${gcd1}`);
    io:println(string`GCD Calcl [4736, 82] = ${gcd2}`);
}
