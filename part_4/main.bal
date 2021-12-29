import ballerina/io;

//---------------------------------//
//----------   Strand    ----------//
//---------------------------------//
// Logical Thread of Control (more like couroutines in kotlin)
// Each named worker has a `strand`
// Execution switches between strands only at specific `yield` points
//      - doing a wait
//      - when a library function invokes a blocking system call
// Annotation can be used to make a strand run on a seperate thread (physical thread)
//---------------------------------//


function workerReturnValue(string s) returns int|error {
    // workers can return values
    worker converter returns int|error {
        int x = check int:fromString(s);
        return x + 1;
    }
    int y = check wait converter;
    return y + 1;
}

function fetchData(string url) returns string|error {
    return url;
}

// fetch data from either `urlA` of `urlB`
function alternativeFetch(string urlA, string urlB) returns string|error {
    worker A returns string|error {
        return fetchData(urlA);
    }

    worker B returns string|error {
        return fetchData(urlB);
    }

    return wait A|B;
}

// wait for multiple workers
type Result record {
    string|error a;
    string|error b;
};

function multiFetch(string urlA, string urlB) returns Result {
    worker WA returns string|error {
        return fetchData(urlA);
    }

    worker WB returns string|error {
        return fetchData(urlB);
    }
    return wait { a: WA, b: WB };
    // alternatively we could use following shorthand
    // `wait { X, Y };`
    // above expression evaluates to `wait { X: X, Y: Y}`
    // above shorthand works with futures as well
}

// - when directly returned a worker the return value will be a `future`
// - `start` is a sugar for calling a function with a named worker 
// and returning the named worker as a future
// - cancellation of `future` only happens at yield points
function workerDirectReturn() returns future<int> {
    worker A returns int {
        return 42;
    }
    return A;
}

type IntFunc function() returns int;

function startInt(IntFunc fun) returns future<int> {
    worker functionWorker returns int {
        return fun();
    }
    return functionWorker;
}

// workers can send/receive messages to/from workers
// this is validate at compile-time
function messaging() returns int {
    worker A {
        // send `1` to worker `B`
        1 -> B;
        2 -> C;
    }

    worker B {
        // receive int from worker `A`
        int recA = <- A;
        // send int to `function` worker
        recA -> function;
    }

    worker C {
        int recA = <- A;
        recA -> function;
    }

    // receive int sent by worker `B` to the `function` worker
    int recB = <- B;
    int recC = <- C;
    return recB + recC;
}

function messagingFailure(string s) returns int|error {
    worker A returns error? {
        int value = check int:fromString(s);
        value -> function;
    }
    int resolvedValue = check <- A;
    return resolvedValue;
}

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

// normally all of function's code belongs to the function's `default worker`
// function can declare name workers which run concurrently function's default worker and other named workers
public function main() {
    // function level variables are available for access inside the wokers as well
    int counter = 0;
    io:println(string`Initializing Counter[${counter}]`);

    // named workers can continue to execute after the function's default worker terminates 
    // and the function returns 
    worker A {
        io:println("In Worker A");
        counter+=1;
    }

    worker B {
        io:println("In Worker B");
        counter+=1;
    }

    // If we need to wait until a worker is completed we have to explicitly wait for it
    wait A;
    wait B;

    io:println(string`In Function Worker, Counter[${counter}]`);

    // inter-worker messaging demo
    io:println("Value received from worker-messaging ", messaging());
}
