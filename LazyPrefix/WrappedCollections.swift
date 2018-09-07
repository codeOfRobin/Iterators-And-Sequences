//
//  WrappedCollections.swift
//  LazyPrefix
//
//  Created by Robin Malhotra on 07/09/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

struct TwoArrayWrapper<T>: Collection {

    private let _internalFirst: [T]
    private let _internalSecond: [T]

    init(first: [T], second: [T]) {
        self._internalFirst = first
        self._internalSecond = second
    }

    var startIndex: Int {
        return _internalFirst.startIndex
    }

    var endIndex: Int {
        return _internalSecond.endIndex + _internalFirst.count
    }

    func index(after i: Int) -> Int {
        if i >= _internalFirst.count {
            return _internalSecond.index(after: i)
        } else {
            return _internalFirst.index(after: i)
        }
    }

    subscript(position: Int) -> T {
        if position >= _internalFirst.count {
            return _internalSecond[position]
        } else {
            return _internalFirst[position]
        }
    }


    func something(predicate: (T) -> Bool) -> Bool {
        return self.contains(where: predicate)
    }

}

