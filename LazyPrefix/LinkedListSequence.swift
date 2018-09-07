//
//  LinkedListSequence.swift
//  LazyPrefix
//
//  Created by Robin Malhotra on 07/09/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

// https://www.skilled.io/u/playgroundscon/sequence-and-collection-swift

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

extension Sequence {
    func count(_ shouldCount: (Iterator.Element) -> Bool) -> Int {
        var count = 0
        for element in self {
            if shouldCount(element) { count += 1 }
        }
        return count
    }
}

extension Sequence where Self.SubSequence: Sequence, Self.SubSequence.Iterator.Element == Self.Iterator.Element {
    func eachPair() -> AnySequence<(Iterator.Element, Iterator.Element)> {
        return AnySequence(zip(self, self.dropFirst()))
    }
}
