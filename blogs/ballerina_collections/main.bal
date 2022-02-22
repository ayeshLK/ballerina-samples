import ballerina/io;

public function main() {
    //-- ballerina array samples --//

    // appends the value to the end of the array
    books.push("The Hunger Games: Mockingjay");

    // updates the value in the 0th index of the array
    books[0] = "Harry Potter and the Philosopher's Stone";

    // iterate over books array
    foreach string book in books {
        io:println(book);
    }

    // iterate over array elements along with respective indexes
    foreach [int, string] [idx, book] in books.enumerate() {
        io:println(string `Index [${idx}] Book [${book}]`);
    }

    // --------------------------- //
}