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
