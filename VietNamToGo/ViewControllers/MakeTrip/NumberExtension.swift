//
//  NumberExtension.swift
//  Fuot
//
//  Created by Zoom Nguyen on 1/2/16.
//  Copyright © 2016 Zoom Nguyen. All rights reserved.
//

import Foundation

struct Number {
    static let formatterWithSepator: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
}
extension IntegerType {
    var stringFormatedWithSepator: String {
        return Number.formatterWithSepator.stringFromNumber(hashValue) ?? ""
    }
}