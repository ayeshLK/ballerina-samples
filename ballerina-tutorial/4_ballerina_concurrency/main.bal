import ballerina/io;

public function main() {
    // sample for simple worker
    simpleWorkers();
    
    // inter-worker messaging demo
    io:println("Value received from worker-messaging ", messaging());
}
