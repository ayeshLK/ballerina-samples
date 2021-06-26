type FullName record {
    string firstName;
    string lastName;
};

type Employee record {
    readonly int id;
    FullName name;
};

public function main() {
    string[] books = ["Harry Potter", "Angels & Demons"];

    [string, int] subjectResults = [ "Physics", 90 ];
    string subject = subjectResults[0];
    int results = subjectResults[1];

    map<string> addrMap = {
        line1: "No. 15",
        line2: "David Perera Mw",
        city: "Matara"
    };
    string line1 = addrMap.get("line1");

    FullName name = {
        firstName: "John",
        lastName: "Doe"
    };
    string firstName = name.firstName;

    table<Employee> key (id) employees = table [
        { id: 1, name: { firstName: "John", lastName: "Doe" } },
        { id: 2, name: { firstName: "Will", lastName: "Smith" } }
    ];
    Employee? emp = employees[1];
}


# Calculates the summation of two integers.
#
# + a - First input parameter
# + b - Second input parameter 
# + return - The summation of the two integer parameters
function add(int a, int b) returns int {
    return a + b;
}