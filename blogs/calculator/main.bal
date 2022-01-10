import ballerina/io;

// Prints `Hello, World!`.

public function main() returns error? {
    string literalExpression = "123*12-3";
    Expression expression = check generate(literalExpression);
    float result = check calculate(expression);
    io:println(string `Result of [${literalExpression}] is [${result}]`);
}



// basic logic
// ask two numbers with an operator
// read input
// calculate the result
// print it on the screen

