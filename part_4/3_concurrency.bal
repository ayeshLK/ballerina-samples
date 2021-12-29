int n = 0;

function icrement() {
    // `lock` statement allows mutable state to be safely accessed from multiple strands
    // execution of outermost blocks is not inteleaved
    lock {
        n += 1;
    }
}

type R record {|
    int v;
|};

// this is concurrency safe because value of `N` can not be changed after assigned
final int N = 0;

// a call to an isolated function is concurrency safe
// it is called with arguments which are safe at least until the call returns
isolated function set(R r) {
    r.v = N;
}

// this is not conccurrency safe 
R r = { v: 0 };

// this is not isolated
function setGlobal(int n) {
    r.v = n;
}

// If a value belongs to type `readonly` then the value is immutable
// for a structural type `T`, `T & readonly` means immutable `T`
// `T & readonly` is a subtype of `T` and a subtype of `readonly`
readonly & string[] s = [
    "foo", "bar"
];

type Row record {
    // both field and its value are immutable
    readonly string[] k;
    int value;
};

Row r1 = {
    k: s, value: 17
};

//---------- `readonly` & `isolation` ----------//
type Entry map<json>;
type ReadOnlyMap readonly & Entry;

function loadMap() returns ReadOnlyMap {
    return {};
}

// reference to `roMap` can not be changed (declared `final`)
// `ReadOnlyMap` type is itself `readonly` (ballerina `readonly` is deep)
// hence `roMap` is immutable
final ReadOnlyMap roMap = loadMap();

isolated function lookUp(string 'key) returns readonly & Entry? {
    // since `roMap` is immutable, it is completely safe to access inside a `isolated` function
    // `isolated` functions complements `readonly` data
    if roMap.hasKey('key) {
        return roMap.get('key);
    }
}
