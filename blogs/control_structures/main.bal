import ballerina/io;

function isEvenNumber(int number) returns boolean {
    // checks whether the `number` is divisible by `2`
    if number % 2 == 0 {
        return true;
    } else {
        return false;
    }
}

enum Grade {
    A, B, C, F
}

function calculateGrade(int marks) returns Grade {
    // checks whether the `marks` are greater than or equal to `75`
    if marks >= 75 {
        return A;
    // checks whether the `marks` are less than `75` but greater than or equal to `65`
    } else if marks >= 65 {
        return B;
    // checks whether the `marks` are less than `65` but greater than or equal to `40`
    } else if marks >= 40 {
        return C;
    } else {
        return F;
    }
}

function isNumber(any value) returns boolean {
    // checks whether the provided value is an `int` or a `float`
    if value is int || value is float {
        return true;
    }
    return false;
}

function isString(any value) returns boolean {
    // checks whether the provided value is not a `string`
    if value !is string {
        return false;
    }
    return true;
}

function dayOfTheWeek(int date) returns string {
    match date {
        1 => {
            return "Monday";
        }
        2 => {
            return "Tuesday";
        }
        3 => {
            return "WednesDay";
        }
        4 => {
            return "Thursday";
        }
        5 => {
            return "Friday";
        }
        6 => {
            return "Saturday";
        }
        // default clause
        _ => {
            return "Sunday";
        }
    }
}

function isDivisibleByFive(int number) returns string {
    int lastDigit = number / 10;
    match lastDigit {
        // check whether last digit is `0` or `5`
        0|5 => {
            return "Divisible by Five";
        }
        _ => {
            return "Not Divisible by Five";
        }
    }
}

function sum(int[] values) returns int {
    int sum = 0;
    // `foreach` can be used with an `array`
    // each iteration returns a value in the `array`
    foreach int value in values {
        sum += value;
    }
    return sum;    
}

function factorial(int n) returns int {
    int result = 1;
    // iterates over values starting from `1` to `n`
    foreach int value in 1..< n+1 {
        result *= value;
    }
    return result;
}

function printEvenNumbersInRange(int range) {
    int n = 1;
    // run this loop until `n` is greater than or equal to `range` value
    while n < range {
        if n % 2 == 0 {
            io:println(n);
        }
    }
}

function leastCommonMultiple(int a, int b) returns int {
    int counter = 1;
    while true {
        counter += 1;
        // if the `counter` is divisible by `a` and `b` break the loop
        if counter % a == 0 && counter % b == 0 {
            break;
        }
    }
    return counter;
}
