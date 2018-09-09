//
//  LazyScanSequence.swift
//  LazyPrefix
//
//  Created by Robin Malhotra on 09/09/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation


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
