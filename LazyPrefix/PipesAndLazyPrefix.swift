//
//  PipesAndLazyPrefix.swift
//  LazyPrefix
//
//  Created by Robin Malhotra on 18/09/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

infix operator |> : MultiplicationPrecedence
func |> <T, U>(value: T, function: ((T) -> U)) -> U {
    return function(value)
}

func printy(_ something: Any) {
    print(something)
}

func mainLazyPrefix() {
    //: https://twitter.com/codeOfRobin/status/1039066012845584385
    /// Weird early break logic, hard to decipher and debug, state like `flag` and `sentinel` available outside logic where it's running
    var flag = false
    var sentinel: Int? = nil

    for i in (1...10) {
        if i % 8 == 0 {
            flag = true
            sentinel = i
            break
        }
    }
    if flag {
        print("flag was true, stopped at \(String(describing: sentinel))")
    }


    /// Replace this with:

    let x = (1...10).lazy.prefix { (number) -> Bool in
        return !(number % 8 == 0)
    }
    print(Array(x))

}
