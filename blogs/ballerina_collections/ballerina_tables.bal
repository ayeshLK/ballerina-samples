import ballerina/io;

type User record {
    // `username` is used as the key
    // hence it is immutable
    readonly string username;
    string firstName;
    string lastName;
};

table<User> key(username) users = table [
    {username: "user1", firstName: "John", lastName: "Doe"},
    {username: "user2", firstName: "Allie", lastName: "Grater"}
];

function accessTable() {
    User? user2 = users["user2"];

    // use `get` lang-lib function only when you know that the table has a specific key
    User user1 = users.get("user1");

    foreach User user in users {
        io:println(string `${user.firstName} ${user.lastName}`);
    }
}

type BankAccount record {
    // Combination of `accountNumber` and `accountType` is the key
    readonly string accountNumber;
    readonly string accountType;
    string accountName;
};

table<BankAccount> key(accountNumber, accountType) accounts = table [
    {accountNumber: "1234", accountType: "current-account", accountName: "John Doe"},
    {accountNumber: "1234", accountType: "savings-account", accountName: "Jane Doe"}
];

function accessTableWithMultipleKeys() {
    BankAccount? account = accounts["1234", "current-account"];
}

type BankAccount2 record {
    // `accountId` is a structured-key
    readonly record {
        string accountNumber;
        string accountType;
    } accountId;
    string accountName;
};

table<BankAccount2> key(accountId) accounts2 = table [
    {accountId: {accountNumber: "1234", accountType: "current-account"}, accountName: "John Doe"},
    {accountId: {accountNumber: "1234", accountType: "savings-account"}, accountName: "Jane Doe"}
];

function accessTableWithStructuredKeys() {
    BankAccount2? account = accounts2[{accountNumber: "1234", accountType: "current-account"}];
}

type Employee record {|
    readonly int id;
    record {
        string firstName;
        string lastName;
    } name;
    int salary;
    int age;
|};

table<Employee> key(id) employees = table [
    {id: 1, name: {firstName: "John", lastName: "Doe"}, salary: 100, age: 35},
    {id: 2, name: {firstName: "Jane", lastName: "Doe"}, salary: 300, age: 32}
];

// iterates over the table and for each row it will extract the value of the `salary` field and binds it to `s`
int[] salaries = from var {salary: s} in employees
    select s;

// selects all the employees who are older than 40 years
table<Employee> key(id) olderEmployees = 
    check table key(id)
    from Employee e in employees
    where e.age > 40
    select e;

// selects the full name of the employees
string[] names = 
    from Employee e in employees
    let string name = string `${e.name.firstName} ${e.name.lastName}`
    select name; 

type Login readonly & record {|
    string username;
    string time;
|};

Login[] logins = [
    {username: "user2", time: "18:00:00"},
    {username: "user1", time: "20:10:23"},
    {username: "user2", time: "21:30:00"},
    {username: "user1", time: "21:35:10"}
];

string[] loginDetails = from Login login in logins
    join User u in users on login.username equals u.username
    select string `${u.firstName} ${u.lastName} - ${login.time}`;
    