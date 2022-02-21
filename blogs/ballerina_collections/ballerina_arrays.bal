import ballerina/io;

public function main() {
    string[] books = ["Harry Potter", "Angels & Demons"];
    string bookOne = books[0];
    
    // appends the value to the end of the array
    books.push("The Hunger Games: Mockingjay");

    // updates the value in the 0th index of the array
    books[0] = "Harry Potter and the Philosopher's Stone";

    int[] values1 = [1, 2, 3, 4, 5];
    int[] values2 = [2, 4, 1, 5, 3];

    // `isEqual` will be `false`
    boolean isEqual = values1 == values2;

    // iterate over books array
    foreach string book in books {
        io:println(book);
    }

    // iterate over array elements along with respective indexes
    foreach [int, string] [idx, book] in books.enumerate() {
        io:println(string `Index [${idx}] Book [${book}]`);
    }
}
