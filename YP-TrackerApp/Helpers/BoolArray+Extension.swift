//
//  BoolArray+Extension.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 12.07.2023.
//

import Foundation

extension [Bool] {

    func boolString() -> String {
        var result = ""
        for bool in self {
            if bool == true {
                result += "1"
            } else {
                result += "0"
            }
        }
        return result
    }

}
