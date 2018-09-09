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
    let predicate: (Element) -> Bool
}

struct LazyPrefixSequence<Base: Sequence>: LazySequenceProtocol {
    func makeIterator() -> LazyPrefixIterator<Base.Iterator> {
        return LazyPrefixIterator(base: base.makeIterator(), predicate: predicate)
    }
    let base: Base
    let predicate: (Element) -> Bool
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


let x = (1..<6).lazy.scan(0, { (result, element) in
    print("running for \(element)")
    return result + element
})

print(Array(x.prefix(3)))


print((1...5).eachPair())
