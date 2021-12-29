import ballerina/io;

// sql like syntax for list-comprehensions
int[] nums = [1, 2, 3, 4, 5];

// result is [10, 20, 30, 40, 50]
int[] numsTimes10 = 
            from var i in nums
            select i * 10;

// result is [2, 4]
int[] evenNumbers = 
            from var i in nums
            where i % 2 == 0
            select i;

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

// deconstruction of record is available as a lang feature
type Person record {|
    string firstName;
    string lastName;
    int age;
    int salary;
|};

Person[] employees = [];

// projection with `firstName` and `lastName`
var names1 = 
        from var { firstName: f, lastName: l } in employees
        select { firstName: f, lastName: l };

var names2 =
        from var { firstName, lastName } in employees
        select { firstName, lastName };

// selecting the names
// could have multiple `let` / `where` clauses in this sytax
string[] names = 
        from var { firstName, lastName } in employees
        let int len1 = firstName.length()
        where len1 > 0
        let int len2 = lastName.length()
        where len2 > 0
        let string name = string`${firstName} ${lastName}`
        select name;

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

// ordering a list using query-expressions
Person[] sorted = 
        from var e in employees
        order by e.lastName ascending, e.firstName ascending
        select e;

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

// limiting the results using `limit` clause
Person[] top100 = 
        from var e in employees
        order by e.salary descending
        limit 100
        select e;

// ----------------------------------------------------------- //
// ----------------------------------------------------------- //

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

// ballerina has first class support for XML
// xml is considered as sequences

string url = "http://sample.ballerina.com/home";
xml content = xml`<a href="${url}">Ballerina</a> is an <em>exciting</em> new language!`;
xml p = xml`<p>${content}</p>`;

xml x1 = xml`<p id="greeting">Hello World!</p>`;
string paraId = check x1.id;

xml:Element elem = xml`<p>Hello</p>`;

function stringToXml(string text) returns xml:Text {
    return xml:createText(text);
}

function rename(xml x, string oldName, string newName) {
    foreach xml:Element e in x.elements() {
        if (e.getName() == oldName) {
            e.setName(newName);
        }
        rename(e.getChildren(), oldName, newName);
    }
}

type Subject record {|
    string name;
    int credits;
|};

function subjectToXml(Subject[] subjects) returns xml {
    return xml`<data>${
        from var {name, credits} in subjects
        select xml`<subject name="${name}" credits="${credits}">${name}</subject>`
    }</data>`;
}

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



