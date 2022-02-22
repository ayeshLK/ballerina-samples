import ballerina/io;

public function main() {
    //-- ballerina array samples --//

    // appends the value to the end of the array
    books.push("The Hunger Games: Mockingjay");

    // updates the value in the 0th index of the array
    books[0] = "Harry Potter and the Philosopher's Stone";

    // iterate over books array
    foreach string book in books {
        // io:println(book);
    }

    // iterate over array elements along with respective indexes
    foreach [int, string] [idx, book] in books.enumerate() {
        // io:println(string `Index [${idx}] Book [${book}]`);
    }

    // --------------------------- //

    //--  ballerina map samples  --//

    // updates the value for `x` key in the map
    m["x"] = 10;

    // retrieves a nilable value for key `x`
    int? nilableValue = m["x"];

    // retrieve the value for key, panics if the key is not present
    int value = m.get("x");

    // iterates over all the values of the map `m`
    foreach int val in m {
        io:println(val);
    }

    // iterates over the values of a map of [key, value] pairs of map `subjectMarks`
    foreach [string, int] [subject, marks] in subjectMarks.entries() {
        io:println(string `Marks for ${subject} is ${marks}.`);
    }

    // maps the marks for subjects to the grade
    map<string> subjectGrades = subjectMarks.'map(function(int marks) returns string {
        if marks >= 75 {
            return "A";
        } else if marks >= 65 {
            return "B";
        } else if marks >= 40 {
            return "S";
        } else {
            return "F";
        }
    });

    // checks whether the map `m` has the key `y`
    boolean isKeyPresent = m.hasKey("y");

    // --------------------------- //
}