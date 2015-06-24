// Playground - noun: a place where people can play

import UIKit
import Foundation

var str = "Hello, playground"

let formatter = NSDateFormatter();
formatter.dateFormat = "yyyy-MM-dd"

let timeStr_1 = "2014-5-20"


let formatter_2 = NSDateFormatter();

formatter_2.dateFormat = "yyyy-MM-dd hh:mm:ss"


println(formatter.dateFromString(timeStr_1))
println(formatter_2.dateFromString(timeStr_1))

formatter.dateFromString(timeStr_1) ? : formatter_2.dateFromString(timeStr_1)
