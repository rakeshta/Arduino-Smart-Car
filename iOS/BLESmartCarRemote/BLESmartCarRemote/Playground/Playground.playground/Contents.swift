//: Playground - noun: a place where people can play

import UIKit


let a0 = 0x03 as UInt8
let a1 = 0xCF as UInt8
let ax = Int16(a0) << 0x08 | Int16(a1)
sizeof(a0.dynamicType)

let s = Int16(-400)
let u = s & (Int16(0xFF) << 0x08)