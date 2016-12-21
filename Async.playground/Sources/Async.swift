//
//  Async.swift
//  
//
//  Created by Andreas Neusüß on 12.05.16.
//  Copyright © 2016 Andreas Neusuess. All rights reserved.
//

import Foundation


// Sample code once again so that you do not have to visit GitHub every time you want to look something up.
//Async.async(QOS: .Main, block: {
//    print("starting Task 1")
//    let timeToSleep = 1.0
//    print("Spleeping for \(timeToSleep)")
//    NSThread.sleepForTimeInterval(timeToSleep)
//    print("Finish task 1")
//    
//}).then(after: 3, QOS: .Background) {
//    print("starting Task 2")
//    let timeToSleep = 2.0
//    print("Spleeping for \(timeToSleep)")
//    NSThread.sleepForTimeInterval(timeToSleep)
//    print("Finish task 3")
//}
//
////Or you can use this syntax:
//Async.main(block: {
//    print("starting Task 1")
//    let timeToSleep = 1.5
//    print("Spleeping for \(timeToSleep)")
//    NSThread.sleepForTimeInterval(timeToSleep)
//    print("Finish task 1")
//    
//}).main(after: 3, block: {
//    print("starting Task 2")
//    let timeToSleep = 2.1
//    print("Spleeping for \(timeToSleep)")
//    NSThread.sleepForTimeInterval(timeToSleep)
//    print("Finish task 2")
//}).main(after: 5, block: {
//    print("starting Task 3")
//    let timeToSleep = 3.3
//    print("Spleeping for \(timeToSleep)")
//    NSThread.sleepForTimeInterval(timeToSleep)
//    print("Finish task 3")
//})









/**
 Enum defining the stages of 'Quality Of Service'.
 
 
 - Main:            Operations on the main thread. Always perform UI updates on this thread.
 - UserInteractive: Priority that should be set if the user initiated the operation and waits for it to finish.
 - UserInitiated:   Priority that should be set if the user initiated the operation.
 - Default:         Default priority.
 - Utility:         Work that may take some time to complete and doesn’t require an immediate result, such as downloading or importing data.
 - Background:      Work that operates in the background and isn’t visible to the user, such as indexing, synchronizing, and backups.
 
 ref: https://developer.apple.com/library/ios/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html
 */
public enum QualityOfService {
    case main, userInteractive, userInitiated, `default`, utility, background
}

public struct Async {
    
    /// Storing the block in a DispatchWorkItem to attach completion blocks to it.
    fileprivate var workItem : DispatchWorkItem
    
    /**
     Perform a async operation on the main queue.
     
     **What kind of operations should be performed on the main queue?**
     
     Perform any kind of UI operations on the main thread. *Always.*
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public static func main(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.main)
        return Async.scheduleBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *background* priority.
     
     **What kind of operations should be performed on the main queue?** *Apples documentation says:*
     Work that operates in the background and isn’t visible to the user, such as indexing, synchronizing, and backups. Focuses on energy efficiency.
     
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public static func background(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.background)
        
        return Async.scheduleBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *user-interactive* priority.
     
     **What kind of operations should be performed on the main queue?** *Apples documentation says:*
     Work that is interacting with the user, such as operating on the main thread, refreshing the user interface, or performing animations. If the work doesn’t happen quickly, the user interface may appear frozen. Focuses on responsiveness and performance.
     
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public static func userInteractive(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.userInteractive)
        
        return Async.scheduleBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *user-initiated* priority.
     
     **What kind of operations should be performed on the main queue?** *Apples documentation says:*
     Work that the user has initiated and requires immediate results, such as opening a saved document or performing an action when the user clicks something in the user interface. The work is required in order to continue user interaction. Focuses on responsiveness and performance.
     
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public static func userInitiated(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.userInitiated)
        
        return Async.scheduleBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *utility* priority.
     
     **What kind of operations should be performed on the main queue?** *Apples documentation says:*
     Work that may take some time to complete and doesn’t require an immediate result, such as downloading or importing data. Utility tasks typically have a progress bar that is visible to the user. Focuses on providing a balance between responsiveness, performance, and energy efficiency.
     
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public static func utility(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.utility)
        
        return Async.scheduleBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *default* priority.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public static func defaultPriority(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.default)
        
        return Async.scheduleBlock(after: after, block: block, onQueue: queue)
    }
    
    
    
    /**
     Generalized function to provide an alternative syntax for queueing a block.
     You can call this method with a gviven QOS parameter to specify the queue on which the block should be performed on.
     
     This method plays along nicer with the ```.than``` method but again, it's just an optional way to query blocks by not using one of the above methods.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter QOS:   QualityOfService that specifies on which priority the block should be run. For example, you can provide .Main to run on the main queue or .Background to run on a background priority queue.
     - parameter block: The block that will be executed. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public static func async(_ after: Double? = nil, QOS: QualityOfService, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(QOS)
        
        return Async.scheduleBlock(after: after, block: block, onQueue: queue)
    }
    
    
    /**
     Function to collect calls to ```Async.Main(...)```, .```Background(...)``` and others to perform the operation.
     Performing a dispatch_after if a delay is specified or dispatch_group_async otherwise.
     
     - parameter delay: Delay in seconds after which the code will be executed.
     - parameter block: The block that should be scheduled.
     - parameter queue: Queue on which the block should be run.
     
     - returns: Async object for example to chain another block to.
     */
    fileprivate static func scheduleBlock(after delay: Double? = nil, block: @escaping ()->(), onQueue queue: DispatchQueue) -> Async {
        
                // Creating a copy by inheriting the original QOS_Class to chain other blocks by using dispatch_notify to it.
//        let newblock = dispatch_block_create(__DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        
        let newblock = DispatchWorkItem(qos: .default, flags: .inheritQoS, block: block)
        
        
        if let delayInSeconds = delay {
            
            queue.asyncAfter(deadline: .now() + delayInSeconds, execute: newblock)
        }
        else {
            let group = DispatchGroup()
            
            queue.async(group: group, execute: newblock)
        }
        
        
        return Async(workItem: newblock)
    }
    
    
    /**
     Matches a QualityOfService case to an actual dispatch_queue_t.
     It uses ```dispatch_get_main_queue()``` if the main queue is requested or ```dispatch_get_global_queue()``` with desired QOS_Class otherwise.
     
     - parameter qos: The Quality Of Service that the user requests, for example .Main or .Background.
     
     - returns: A queue of type dispatch_queue_t. Blocks can be scheduled on this queue.
     */
    fileprivate static func queueForQualityOfService(_ qos: QualityOfService) -> DispatchQueue {
        
        let qualityOfServiceClass : DispatchQoS.QoSClass
        
        switch qos {
        case .main:
            return DispatchQueue.main
        case .userInteractive:
            qualityOfServiceClass = DispatchQoS.QoSClass.userInteractive//DispatchQoS.userInteractive//DispatchQoS.QoSClass.userInteractive
        case .userInitiated:
            qualityOfServiceClass = DispatchQoS.QoSClass.userInitiated
        case .default:
            qualityOfServiceClass = DispatchQoS.QoSClass.default
        case .utility:
            qualityOfServiceClass = DispatchQoS.QoSClass.utility
        case .background:
            qualityOfServiceClass = DispatchQoS.QoSClass.background
        }
        
        let queue = DispatchQueue.global(qos: qualityOfServiceClass)
        return queue
        
    }
    
    
    /**
    Perform a async operation on the main queue after previous block is done.
    
    **What kind of operations should be performed on the main queue?**
    
    Perform any kind of UI operations on the main thread. *Always.*
    
    - parameter after: Delay after which the block is executed. Defaults to no delay.
    - parameter block: The block that will be executed when the previous block is done. The method chains them together. A copy is made to apply a completion block to it.
    
    - returns: Async object for example to chain another block to.
    - seeAlso: QualityOfService
     */
    @discardableResult public func main(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.main)
        
        return chainBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *background* priority after previous block is done.
     
     **What kind of operations should be performed on the main queue?** *Apples documentation says:*
     Work that operates in the background and isn’t visible to the user, such as indexing, synchronizing, and backups. Focuses on energy efficiency.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed when the previous block is done. The method chains them together. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    @discardableResult public func background(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.background)
        
        return chainBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *user-interactive* priority after previous block is done.
     
     **What kind of operations should be performed on the main queue?** *Apples documentation says:*
     Work that is interacting with the user, such as operating on the main thread, refreshing the user interface, or performing animations. If the work doesn’t happen quickly, the user interface may appear frozen. Focuses on responsiveness and performance.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed when the previous block is done. The method chains them together. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    @discardableResult public func userInteractive(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.userInteractive)
        
        return chainBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *user-initiated* priority after previous block is done.
     
     **What kind of operations should be performed on the main queue?** *Apples documentation says:*
     Work that the user has initiated and requires immediate results, such as opening a saved document or performing an action when the user clicks something in the user interface. The work is required in order to continue user interaction. Focuses on responsiveness and performance.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed when the previous block is done. The method chains them together. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    @discardableResult public func userInitiated(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.userInitiated)
        
        return chainBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *utility* priority after previous block is done.
     
     **What kind of operations should be performed on the main queue?** *Apples documentation says:*
     Work that may take some time to complete and doesn’t require an immediate result, such as downloading or importing data. Utility tasks typically have a progress bar that is visible to the user. Focuses on providing a balance between responsiveness, performance, and energy efficiency.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed when the previous block is done. The method chains them together. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    @discardableResult public func utility(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.utility)
        
        return chainBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *default* priority after previous block is done.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed when the previous block is done. The method chains them together. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    @discardableResult public func defaultPriority(_ after: Double? = nil, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(.default)
        
        return chainBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Generalized function to provide an alternative syntax for queueing a block.
     You can call this method with a gviven QOS parameter to specify the queue on which the block should be performed on.
     
     This method plays along nicer with the ```.async``` method but again, it's just an optional way to query blocks by not using one of the above methods.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter QOS:   QualityOfService that specifies on which priority the block should be run. For example, you can provide .Main to run on the main queue or .Background to run on a background priority queue.
     - parameter block: The block that will be executed when the previous block is done. The method chains them together. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    @discardableResult public func then(_ after: Double? = nil, QOS: QualityOfService, block: @escaping ()->()) -> Async {
        let queue = Async.queueForQualityOfService(QOS)
        
        return chainBlock(after: after, block: block, onQueue: queue)
    }

    
    /**
     Function to collect calls to Async chaining methods to perform the operation.
     ```dispatch_block_notify``` is used to chain the given block to the current running operation.
     
     - parameter delay: Delay in seconds after which the code will be executed.
     - parameter block: The block that should be chained.
     - parameter queue: Queue on which the block should be run.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    fileprivate func chainBlock(after delay: Double? = nil, block: @escaping ()->(), onQueue queue: DispatchQueue) -> Async {
//        let newblock = dispatch_block_create(__DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)

        let newblock = DispatchWorkItem(qos: .default, flags: .inheritQoS, block: block)
        
        let blockToSchedule: DispatchWorkItem
        
        if let delayInSeconds = delay {
            //Wrap the blog inside a new blog that perform the delay and is executed immediately after it is notified.
            let delayedExecutionBlock = {
                
                queue.asyncAfter(deadline: .now() + delayInSeconds, execute: newblock)
            }
            
//            blockToSchedule = dispatch_block_create(__DISPATCH_BLOCK_INHERIT_QOS_CLASS, delayedExecutionBlock)
            
             blockToSchedule = DispatchWorkItem(qos: .default, flags: .inheritQoS, block: delayedExecutionBlock)
        }
        else {
            //No delay specified, just register the block copy (newblog) for chaining.
            blockToSchedule = newblock
        }
        
//        dispatch_block_notify(self.block, queue, blockToSchedule)
//        let workItem = DispatchWorkItem(qos: .background, flags: .inheritQoS, block: self.block)
        
        self.workItem.notify(queue: queue, execute: blockToSchedule)
        return Async(workItem: newblock)
    }
}

