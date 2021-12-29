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

// normally all of function's code belongs to the function's `default worker`
// function can declare name workers which run concurrently function's default worker and other named workers
function simpleWorkers() {
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
