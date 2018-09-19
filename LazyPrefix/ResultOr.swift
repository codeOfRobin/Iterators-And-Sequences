//
//  ResultOr.swift
//  LazyPrefix
//
//  Created by Robin Malhotra on 18/09/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

func resultMain() {
    enum Result<Value> {
        case success(Value)
        case failure(Error)

        init(_ value: Value?, or error: Error) {
            if let v = value {
                self = .success(v)
            } else {
                self = .failure(error)
            }
        }
    }

    enum SomeError: Error { case something }

    var int1: Int? = 2
    var int2: Int? = nil

    let result1 = Result(int1, or: SomeError.something)
    // .success(2)

    let result2 = Result(int2, or: SomeError.something)
    // .failure(SomeError.something)


    print(result1)
    print(result2)
}
