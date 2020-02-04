//
//  Queue.swift
//  CoListen
//
//  Created by Josh Ehrlich on 8/7/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import Foundation

class QueuedItem<T>
{
    let value : T
    var next : QueuedItem?
   
    init(value : T)
    {
        self.value = value
        
    }
}

struct Queue<T>
{
    public typealias Element = T
    
    var head : QueuedItem<Element>
    var tail : QueuedItem<Element>
    
    public init()
    {
        tail = QueuedItem<Element?>(value: nil) as! QueuedItem<T> // no shot this is right
        head = tail
        
        
    }
    
    public mutating func deQueue () -> Element?
    {
        if let newHead = head.next
        {
            head = newHead
            return head.value
        }
        else
        {
            return nil
        }
    }
    
    public func isEmpty() -> Bool
    {
        return head === tail
    }
    
    public mutating func enQueue(value : Element)
    {
        tail.next = QueuedItem(value: value)
        tail = tail.next!
    }
    
    
}
