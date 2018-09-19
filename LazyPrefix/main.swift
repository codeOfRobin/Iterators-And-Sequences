//
//  main.swift
//  LazyPrefix
//
//  Created by Robin Malhotra on 04/09/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

struct Box<T: AnyObject> {
    weak var value: T?
    init(value: T) {
        self.value = value
    }
}

class SomethingToObserve {

}

internal class Atomic<Value> {

    private var _value: Value

    internal init(_ value: Value) {
        _value = value
    }

    internal func apply(_ action: (inout Value) -> Void) {
        action(&_value)
    }
}

public class Receiver<Event> {
    private let values = Atomic<[Event]>([])
    public typealias Handler = (Event) -> Void
    private let handlers = Atomic<[Int:Handler]>([:])

    private func broadcast(elements: Int) {
        values.apply { _values in

            let lowerLimit = max(_values.count - elements, 0)
            let indexs = (lowerLimit ..< _values.count)

            for index in indexs {
                let value = _values[index]
                handlers.apply { _handlers in
                    for _handler in _handlers.values {
                        _handler(value)
                    }
                }
            }
        }
    }

    fileprivate func append(value: Event) {
        values.apply { currentValues in
            currentValues.append(value)
        }
        broadcast(elements: 1)
    }
}
