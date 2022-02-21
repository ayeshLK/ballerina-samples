// In mathematics, the Fibonacci numbers, form a sequence, the Fibonacci sequence, 
// in which each number is the sum of the two preceding ones. The sequence starts from 0 and 1.
// eg: 0, 1, 1, 2, 3, 5, 8, 13...

function fibonacci(int n) returns int {
    if n <= 1 {
        return n;
    }
    return fibonacci(n-1) + fibonacci(n - 2);
}

function fibonacciWithoutRecursion(int n) returns int {
    if n <= 1 {
        return n - 1;
    }
    int a = 0;
    int b = 1;
    int result;
    foreach int i in 2...n {
        result = a + b;
        a = b;
        b = result;
    }
    return result;
}

// A number which cannot be divided by any number other than 1 and itself is called a Prime Number.
// eg: 2, 3, 5, 7, 11...

function isPrime(int n) returns boolean {
    if n <= 1 {
        return false;
    }
    int range = (n / 2) + 1;
    foreach int i in 2...range {
        if n % i == 0 {
            return false;
        }
    }
    return true;
}

// In mathematics, the factorial of a non-negative integer `n`, denoted by `n!``, 
// is the product of all positive integers less than or equal to `n`.

function factorial(int n) returns int {
    if n <= 1 {
        return 1;
    }
    return n * factorial(n - 1);
}

function factorialWithoutRecursion(int n) returns int {
    if n <= 1 {
        return 1;
    }
    int result = 1;
    foreach int i in 1...n {
        result *= i;
    }
    return result;
}

// A `palindromic number`` (also known as a `numeral palindrome` or a `numeric palindrome`) 
// is a number (such as 16461) that remains the same when its digits are reversed.

function isPalindrome(int n) returns boolean {
    int temp = n;
    int reverse = 0;
    while temp > 0 {
        reverse *= 10;
        reverse += temp % 10;
        temp /= 10;
    }
    return n == reverse;
}

// A `binary palindrome number` is a number whether the binary representation and the reverse of the 
// binary representation is the same. 

function isBinaryPalindrome(int n) returns boolean {
    int[] reverseBinary = [];
    int temp = n;
    while temp > 0 {
        reverseBinary.push(temp % 2);
        temp /= 2;
    }
    return reverseBinary == reverseBinary.reverse();
}

// In number theory, a `Narcissistic Number`` (also known as a `pluperfect digital invariant`, an `Armstrong number` (after Michael F. Armstrong) 
// or a plus perfect number) is a number that is the sum of its own digits each raised to the power of the number of digits.

function isArmstrong(int n) returns boolean {
    int temp = n;
    int oder = 0;
    // find the number of digits in `n`
    while temp > 0 {
        oder += 1;
        temp /= 10;
    }
    temp = n;
    int result = 0;
    while temp > 0 {
        int remainder = temp % 10;
        int accumulator = remainder;
        foreach int i in 1..<oder {
            accumulator *= remainder;
        }
        result += accumulator;
        temp /= 10;
    }
    return result == n;
}
