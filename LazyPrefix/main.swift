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

class Observer<Event> {
    let handler: (Event) -> Void

    init(handler: @escaping (Event) -> Void) {
        self.handler = handler
    }

    func notify(of event: Event) {
        handler(event)
    }
}

class Observable<Event> {
    var observers: [Box<Observer<Event>>] = []

    func subscribe(with observer: Observer<Event>) {
        let box = Box(value: observer)
        observers.append(box)
    }

    func notify(with event: Event) {
        observers = observers.filter{ $0.value != nil }
        observers.forEach { $0.value?.notify(of: event) }
        print("observers: \(observers.count)")
    }
}

var observer1: Observer<Int>? = Observer.init(handler: { print("\($0) x 2 = \($0 * 2)") })
var observer2: Observer<Int>? = Observer.init(handler: { print("\($0) x 2 = \($0 * 2)") })
var observer3: Observer<Int>? = Observer.init(handler: { print("\($0) x 3 = \($0 * 3)") })

let observable = Observable<Int>()
observable.subscribe(with: observer1!)
observable.subscribe(with: observer2!)
observable.subscribe(with: observer3!)

observable.notify(with: 1)

observer1 = nil

observable.notify(with: 2)

//
//1 x 2 = 2
//1 x 2 = 2
//1 x 3 = 3
//observers: 3
//2 x 2 = 4
//2 x 3 = 6
//observers: 2
//Program ended with exit code: 0
