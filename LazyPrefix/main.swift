//
//  main.swift
//  LazyPrefix
//
//  Created by Robin Malhotra on 04/09/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

print("Hello, World!")

//assert((1..<6).scan(0, +) == [0, 1, 3, 6, 10, 15])

struct LazyPrefixIterator<Base: IteratorProtocol>: IteratorProtocol {

    mutating func next() -> Base.Element? {
        if base.next().map(predicate) == true {
            return base.next()
        } else {
            return nil
        }
    }
    var base: Base
    let predicate: (Base.Element) -> Bool
}

struct LazyPrefixSequence<Base: Sequence>: LazySequenceProtocol {
    func makeIterator() -> LazyPrefixIterator<Base.Iterator> {
        return LazyPrefixIterator(base: base.makeIterator(), predicate: predicate)
    }

    let base: Base
    let predicate: (Base.Element) -> Bool
}

extension LazySequenceProtocol {

    func lazyPrefix(while predicate: @escaping (Self.Element) -> Bool) -> LazyPrefixSequence<Self> {
        return LazyPrefixSequence(base: self, predicate: predicate)
    }
}

infix operator |> : MultiplicationPrecedence
func |> <T, U>(value: T, function: ((T) -> U)) -> U {
    return function(value)
}

func printy(_ something: Any) {
    print(something)
}

(1...10).lazy.lazyPrefix { (something) -> Bool in
    something % 2 == 0
} |> printy




struct LazyScanIterator<Base : IteratorProtocol, ResultElement>: IteratorProtocol {
    mutating func next() -> ResultElement? {
        return nextElement.map { result in
            nextElement = base.next().map { nextPartialResult(result, $0) }
            return result
        }
    }
    var nextElement: ResultElement? // The next result of next().
    var base: Base                  // The underlying iterator.
    let nextPartialResult: (ResultElement, Base.Element) -> ResultElement
}


struct LazyScanSequence<Base: Sequence, ResultElement>: LazySequenceProtocol {

    func makeIterator() -> LazyScanIterator<Base.Iterator, ResultElement> {
        return LazyScanIterator<Base.Iterator, ResultElement>(
            nextElement: initial, base: base.makeIterator(), nextPartialResult: nextPartialResult)
    }
    let initial: ResultElement
    let base: Base
    let nextPartialResult:
    (ResultElement, Base.Element) -> ResultElement

}

extension LazySequenceProtocol {
    func scan<ResultElement>(
        _ initial: ResultElement,
        _ nextPartialResult: @escaping (ResultElement, Self.Element) -> ResultElement
        ) -> LazyScanSequence<Self, ResultElement> {
        return LazyScanSequence(
            initial: initial, base: self, nextPartialResult: nextPartialResult)
    }
}

let x = (1..<6).lazy.scan(0, { (result, element) in
    print("running for \(element)")
    return result + element
})

print(Array(x.prefix(3)))



