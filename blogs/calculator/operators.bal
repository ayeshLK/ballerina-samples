type Operator function (float, float) returns float|error;

function add(float a, float b) returns float {
    return a + b;
}

function substract(float a, float b) returns float {
    return a - b;
}

function multiply(float a, float b) returns float {
    return a * b;
}

function divide(float a, float b) returns float {
    if b is 0f {
        panic error("invalid expression: dividing by zero");
    }
    return a / b;
}

