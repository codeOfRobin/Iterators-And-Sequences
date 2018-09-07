//
//  LinkedListSequence.swift
//  LazyPrefix
//
//  Created by Robin Malhotra on 07/09/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

indirect enum LinkedListNode<T> {
    case value(element: T, next: LinkedListNode<T>)
    case end
}

extension LinkedListNode: Sequence {
    func makeIterator() -> LinkedListIterator<T> {
        return LinkedListIterator(current: self)
    }
}

struct LinkedListIterator<T>: IteratorProtocol {
    var current: LinkedListNode<T>

    mutating func next() -> T? {
        switch current {
        case .end:
            return nil
        case .value(element: let element, next: let next):
            current = next
            return element
        }
    }
}


let end = LinkedListNode<String>.end
let middle = LinkedListNode.value(element: "Malhotra", next: end)
let start = LinkedListNode.value(element: "Robin", next: middle)

var iterator = LinkedListIterator(current: start)
