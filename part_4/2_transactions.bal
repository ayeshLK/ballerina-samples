import ballerina/io;

// ballerina supports transactions in language level
// it is not a transaction memory
// ballerina runtime has a transaction manager
// current transaction is part of the execution context of a strand
// transaction must explicitly commit, by using `commit`
// `commit` may return and error, this error should be handled properly
function simpleTransaction(string s) returns error? {
    transaction {
        int value = check int:fromString(s);
        if value == 0 {
            io:println("Received zero value");
        }
        check commit;
    }
}

function understandCheck(string s) returns error? {
    do {
        int value = check int:fromString(s);
        if value == 0 {
            return error("Received a zero value");
        }
    } on fail var e {
        return e;
    }
}

// if there is a fail or a panic in the block, the transaction if rollbacked
// transaction block can also contains a rollback statement
// transaction statement can contain on of the following exits
// - pass through an explicit commit
// - pass through an explicit rollback
// - fail exit
// - panic exit
// rollback does not automatically restore ballerina variables to values before the transaction
type Update record {
    int value;
};

function update(Update[] updates) returns error? {
    transaction {
        foreach Update update in updates {
            check doUpdate(update);
        }
        check commit;
    }
}

function doUpdate(Update update) returns error? {
    // implement logic
}

// in ballerina, we could retry a transaction
function retryableTransaction(string s) returns error? {
    // following is a short hand for
    // ```retry<error:DefaultRetryManager>(3) transaction```
    // if we need more control on the retries, we could implement `error:RetryManager` type and provide it here
    // `retry` only works for `error:Retriable` error types
    retry transaction {
        check stage1();
        check stage2();
        check commit;
    }
}

function stage1() returns error? {}
function stage2() returns error? {}

// in compile-time regions of the code are typed as being a transactional context
// a function with a transactional qualifier can only be called from a transactional context
transactional function simpleTransactionalContext(Update u) returns error? {
    // can call non-transactional functions
    foo();
    // can call transactional functions
    bar();
}

function foo() {
    // you can check whether this function is called within a transactional context
    if transactional {
        // following is valid hence this is inside a transactional context
        bar();
    }
    // following is invalid hence it is out of transactional context
    // bar();
}

// can only be called from within a transactional context
transactional function bar() {}
