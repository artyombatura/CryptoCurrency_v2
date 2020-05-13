//
//  DateExtension.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/13/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
