import ballerina/io;

// `table` is another data strucuture provided by ballerina
// more like sql-tables
// works with `primary-key` concept
//
// one field in the field-type in the table should be readonly which should be used as primary key
// here field type is `Fruit` and primary-key will be `id`
type Fruit record {|
    readonly int id;
    string name;
    string[] nutritions;
|};

// multiple-fields could be a key
type ElectronicEquipment record {|
    readonly string brand;
    readonly string model;
    readonly string id;
    string name;
    string description;
|};

// table could have a structured key
type Student record {|
    readonly record {
        string first;
        string last;
    } name;
    int age;
|};

// table could have joins
type User record {|
    readonly int id;
    string name;
|};

type Login record {|
    int userId;
    string time;
|};

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

// `stream` represents a sequence of values that are generated as needed
// `stream` ends with either `()` or `error`

type LS stream<string,error?>;

// strip blank values
function strip(LS lines) returns LS {
    return 
        stream from var line in lines
        where line.trim().length() > 0
        select line;    
}

// function count(LS lines) returns int|io:Error {
//     int nLines = 0;
//     check from var line in lines
//     do {
//         nLines += 1;
//     }  
//     return nLines;
// }

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

public function main() {
    table<Fruit> key (id) fruits = table [
        { id: 1, name: "apple", nutritions: ["calcium"] },
        { id: 2, name: "orange", nutritions: ["vitamin-c"] }
    ];

    Fruit? f1 = fruits[1];

    // foreach iterates over table in-order
    foreach Fruit f in fruits {
        io:println(string`Fruit name is [${f.name}]`);
    }

    // working with multi-field keys
    table<ElectronicEquipment> key (brand, model, id) equipments = table [
        {
            brand: "LG",
            model: "G-PRO-2",
            id: "SEC-LG-123",
            name: "LG_G_PRO2 Smart Phone",
            description: "This is a smart phone which has 4G enabled"
        }
    ];
    ElectronicEquipment? e = equipments[ "LG", "G-PRO-2", "SEC-LG-123" ];

    // working with structured keys
    table<Student> key (name) students = table [
        { name: { first: "Ayesh", last: "Almeida" }, age: 28 }
    ];
    Student? s = students[ { first: "Ayesh", last: "Almeida" } ];

    // following generates a list of students
    int[] agesOfStudents = 
            from var { age } in students
            select age;

    // following generates a table of students
    var overAgeStudents = 
            table key (name)
            from var st in students
            where st.age > 21
            select st;
    if (overAgeStudents is error) {
        io:println("Error occurred while filtering over-aged students ", overAgeStudents.message());
    }

    // tables could use `join` expressions
    table<User> key(id) users = table [
        { id: 1, name: "John Doe" },
        { id: 2, name: "Jim Doe" }
    ];
    Login[] logins = [
        { userId: 1, time: "2021-05-07 15:00 +0530 UTC"}
    ];
    string[] loginDetail = 
                from var login in logins
                join var user in users
                    on login.userId equals user.id
                select string`${user.name} -> ${login.time}`; 
}



