//
//  Async.swift
//  
//
//  Created by Andreas Neusüß on 12.05.16.
//  Copyright © 2016 Andreas Neusuess. All rights reserved.
//

import Foundation
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
    case Main, UserInteractive, UserInitiated, Default, Utility, Background
}

public struct Async {
    
    /// Storing the block in a var to attach completion blocks to it.
    private var block : dispatch_block_t
    
    /**
     Perform a async operation on the main queue.
     
     **What kind of operations should be performed on the main queue?**
     
     Perform any kind of UI operations on the main thread. *Always.*
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public static func main(after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.Main)
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
    public static func background(after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.Background)
        
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
    public static func userInteractive(after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.UserInteractive)
        
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
    public static func userInitiated(after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.UserInitiated)
        
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
    public static func utility(after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.Utility)
        
        return Async.scheduleBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *default* priority.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public static func defaultPriority(after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.Default)
        
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
    public static func async(after after: Double? = nil, QOS: QualityOfService, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(QOS)
        
        return Async.scheduleBlock(after: after, block: block, onQueue: queue)
    }
    
    
    /**
     Function to collect calls to Async.Main(...), .Background(...) and others to perform the operation.
     Performing a dispatch_after if a delay is specified or dispatch_group_async otherwise.
     
     - parameter delay: Delay in seconds after which the code will be executed.
     - parameter block: The block that should be scheduled.
     - parameter queue: Queue on which the block should be run.
     
     - returns: Async object for example to chain another block to.
     */
    private static func scheduleBlock(after delay: Double? = nil, block: dispatch_block_t, onQueue queue: dispatch_queue_t) -> Async {
        
                // Creating a copy by inheriting the original QOS_Class to chain other blocks by using dispatch_notify to it.
        let newblock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        
        if let delayInSeconds = delay {
            let popTime = dispatch_time(DISPATCH_TIME_NOW,
                                        Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, queue, newblock)
        }
        else {
            let group = dispatch_group_create()
            
            dispatch_group_async(group, queue, newblock)
        }
        
        
        return Async(block: newblock)
    }
    
    
    /**
     Matches a QualityOfService case to an actual dispatch_queue_t.
     It uses dispatch_get_main_queue() if the main queue is requested or dispatch_get_global_queue() with desired QOS_Class otherwise.
     
     - parameter qos: The Quality Of Service that the user requests, for example .Main or .Background.
     
     - returns: A queue of type dispatch_queue_t. Blocks can be scheduled on this queue.
     */
    private static func queueForQualityOfService(qos: QualityOfService) -> dispatch_queue_t {
        
        let qualityOfServiceClass : qos_class_t
        
        switch qos {
        case .Main:
            return dispatch_get_main_queue()
        case .UserInteractive:
            qualityOfServiceClass = QOS_CLASS_USER_INTERACTIVE
        case .UserInitiated:
            qualityOfServiceClass = QOS_CLASS_USER_INITIATED
        case .Default:
            qualityOfServiceClass = QOS_CLASS_DEFAULT
        case .Utility:
            qualityOfServiceClass = QOS_CLASS_UTILITY
        case .Background:
            qualityOfServiceClass = QOS_CLASS_BACKGROUND
        }
        
        let queue = dispatch_get_global_queue(qualityOfServiceClass, 0)
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
    public func main(after after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.Main)
        
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
    public func background(after after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.Background)
        
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
    public func userInteractive(after after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.UserInteractive)
        
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
    public func userInitiated(after after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.UserInitiated)
        
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
    public func utility(after after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.Utility)
        
        return chainBlock(after: after, block: block, onQueue: queue)
    }
    
    /**
     Perform a async operation a queue that runs with *default* priority after previous block is done.
     
     - parameter after: Delay after which the block is executed. Defaults to no delay.
     - parameter block: The block that will be executed when the previous block is done. The method chains them together. A copy is made to apply a completion block to it.
     
     - returns: Async object for example to chain another block to.
     - seeAlso: QualityOfService
     */
    public func defaultPriority(after after: Double? = nil, block: dispatch_block_t) -> Async {
        let queue = Async.queueForQualityOfService(.Default)
        
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
    public func then(after after: Double? = nil, QOS: QualityOfService, block: dispatch_block_t) -> Async {
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
    private func chainBlock(after delay: Double? = nil, block: dispatch_block_t, onQueue queue: dispatch_queue_t) -> Async {
        let newblock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        
        let blockToSchedule: dispatch_block_t
        
        if let delayInSeconds = delay {
            //Wrap the blog inside a new blog that perform the delay and is executed immediately after it is notified.
            let delayedExecutionBlock = {
                
                let popTime = dispatch_time(DISPATCH_TIME_NOW,
                                            Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, queue, newblock)
            }
            
            blockToSchedule = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, delayedExecutionBlock)
            
        }
        else {
            //No delay specified, just register the block copy (newblog) for chaining.
            blockToSchedule = newblock
        }
        
        dispatch_block_notify(self.block, queue, blockToSchedule)
        
        
        return Async(block: newblock)
    }
}

