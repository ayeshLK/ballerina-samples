import ballerina/io;

// functions parameters can have default values
// default values can use values of preceding parameters
function substring(string str, int 'start = 0, int end = str.length()) returns string {
    string[] chars = [];
    foreach int idx in 'start..<end {
        string character = str[idx];
        chars.push(character);    
    }
    return string:'join("", ...chars);
}

// arguments can supply by name as well as position
// all of the following function invocations are valid and should produce equal results
// - foo(1, 2, 3);
// - foo(z = 3, x = 1, y = 2);
// - foo(1, z = 3, y = 2);
function foo(int x, int y, int z) {}

type Date record {|
    int year;
    int month;
    int day;
|};

type Time record {|
    int hour;
    int minute;
    decimal seconds;
|};

type DateTime record {|
    // include `Data` record type to the type descriptor of `DateTime`
    // similar to copying all the fields of `Date` into `DateTime`
    *Date;
    *Time;
|};

type Options record {
    boolean verbose;
    string outputFile = "tmp.txt";
};

// if a function has `*T obj` kind of parameter we call it included record parameter
// with included record parameters
// - function defines record for named parameter
// - caller supplies parameter by name
//   eg: copy("file.txt", verbose = true);
function copy(string inputFile, *Options options) {}

// record fields can have default values
// when using `cloneWithType(T)` will make use of default values specified by `T`
// when using as an included record parameter, it copies the default values
type X record {
    string str = "";
};

// object type is just a type without implementation
// similar to interfaces in java
// object type is structural - object type is like a pattern that a object should match
type Hashable object {
    function hash() returns int;
};

function getHashable() returns Hashable {
    // belongs to `Hashable` type
    return object {
        function hash() returns int {
            return 10;
        }
    };
}

type Clonable object {
    function clone() returns Clonable;
};

// object type inclusion is possible
type Shape object {
    // now the `Shape` object type includes everything from `Clonable` object type
    *Clonable;
    function draw();
};

// class declarations can have type object inclusion 
class Circle {
    // `Circle` class should have the properties inherited from `Shape` type
    *Shape;
    
    // it should implement `clone` since `Shape` is inherited from `Clonable`
    function clone() returns Circle {
        return new;
    }

    // it should implement `draw` since it is inherited from `Shape`
    function draw() {
        
    }
}

// distinct object types provides the capabilities of nominal typing (name has a prominence)
// this is significant because ballerina has a structural type system
// a distinct object value is tagged with a type-id that is unique to that occurence of distinct in the source
type Person distinct object {
    string name;
};

// both object type and class can be distinct
distinct class Employee {
    *Person;
    function init(string name) {
        self.name = name;
    }
}

// object is readonly if its fields are readonly and final
// `readonly & T` is allowed when `T` is an object type
type TimeZone readonly & object {
    readonly & string name;

    function getOffSet(decimal utc) returns decimal;
};

// if a class declaration uses `readonly`
// - object type defined by the class is `readonly & T` (`T` is type described by the class)
readonly class FixedTimeZone {
    *TimeZone;
    final decimal offset;
    
    function init(string name, decimal offset) {
        self.name = name;
        self.offset = offset;
    }

    function getOffSet(decimal utc) returns decimal {
        return self.offset;
    }
}

type HttpDetail record {
    int statusCode;
};

function toInt(string number) returns int|error {
    var value = int:fromString(number);
    if value is error {
        // `error` can have a cause which caused the error (an error itself)
        // this can be passed to the `error` constructor as the second argument
        // - error(message, cause);
        // `error.cause()` will get the cause of the error
        return error("not an integer", value);
    } else {
        return value;
    }
}

type IoError distinct error;

type FileErrorDetail record {
    string fileName;
};

// we can use intersections to define an error type based on both error details and distinct type
type FileIoError IoError & error<FileErrorDetail>;


type Foo object {
    function foo();
};

type Bar object {
    function bar();
};

type FooBar object {
    *Foo;
    *Bar;
};

// type FooBar Foo & Bar;

type T1 record {
    
};

type T2 record {
    
};

type Intersection record {
    *T1;
    *T2;
};

// type Intersection T1 & T2;

public function main() {
    // `e1` has both `Person` and `Employee` as its type
    Employee e1 = new ("ayesh");

    // `error` value contains a map containing arbitary details about the error
    error generalError = error("Error occurred", statusCode = 500);
    
    // type `error<T>` describes error value with detail map of type `T`
    error<HttpDetail> httpError = error("Error occurred", statusCode = 500);
    HttpDetail errorDetail = httpError.detail();
}
