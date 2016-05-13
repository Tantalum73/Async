//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

var str = "Hello, playground"
print("Starting")

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true


Async.async(QOS: .Main, block: {
    print("starting Task 1")
    let timeInterval = Double(arc4random_uniform(100)) * 0.01
    print("Spleeping for \(timeInterval)")
    NSThread.sleepForTimeInterval(1)
    print("Finish task 1")
    
}).then(after: 3, QOS: .Background) { 
    print("starting Task 2")
    let timeInterval = Double(arc4random_uniform(100)) * 0.01
    print("Spleeping for \(timeInterval)")
    NSThread.sleepForTimeInterval(1)
    print("Finish task 3")
}

Async.main(block: {
    print("starting Task 1")
    let timeInterval = Double(arc4random_uniform(100)) * 0.01
    print("Spleeping for \(timeInterval)")
    NSThread.sleepForTimeInterval(1)
    print("Finish task 1")
    
}).main(after: 3, block: {
    print("starting Task 2")
    let timeInterval = Double(arc4random_uniform(100)) * 0.01
    print("Spleeping for \(timeInterval)")
    NSThread.sleepForTimeInterval(1)
    print("Finish task 2")
}).main(after: 5, block: {
    print("starting Task 3")
    let timeInterval = Double(arc4random_uniform(100)) * 0.01
    print("Spleeping for \(timeInterval)")
    NSThread.sleepForTimeInterval(1)
    print("Finish task 3")
})

print("Done")


