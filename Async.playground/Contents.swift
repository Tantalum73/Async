//
//  Async.swift
//
//
//  Created by Andreas Neusüß on 12.05.16.
//  Copyright © 2016 Andreas Neusuess. All rights reserved.
//

import UIKit
import XCPlayground

var str = "Hello, playground"
print("Starting")

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//Use this style:
Async.async(QOS: .Main, block: {
    print("starting Task 1")
    let timeToSleep = 1.0
    print("Spleeping for \(timeToSleep)")
    NSThread.sleepForTimeInterval(timeToSleep)
    print("Finish task 1")
    
}).then(after: 3, QOS: .Background) { 
    print("starting Task 2")
    let timeToSleep = 2.0
    print("Spleeping for \(timeToSleep)")
    NSThread.sleepForTimeInterval(timeToSleep)
    print("Finish task 3")
}

//Or you can use this syntax:
Async.main(block: {
    print("starting Task 1")
    let timeToSleep = 1.5
    print("Spleeping for \(timeToSleep)")
    NSThread.sleepForTimeInterval(timeToSleep)
    print("Finish task 1")
    
}).main(after: 3, block: {
    print("starting Task 2")
    let timeToSleep = 2.1
    print("Spleeping for \(timeToSleep)")
    NSThread.sleepForTimeInterval(timeToSleep)
    print("Finish task 2")
}).main(after: 5, block: {
    print("starting Task 3")
    let timeToSleep = 3.3
    print("Spleeping for \(timeToSleep)")
    NSThread.sleepForTimeInterval(timeToSleep)
    print("Finish task 3")
})

print("Done")


