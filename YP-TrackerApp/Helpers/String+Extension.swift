//
//  String+Extension.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 12.07.2023.
//

import Foundation

extension String {

    func boolArray() -> [Bool] {
        var result = [Bool]()
        for bool in self {
            if bool == "1" {
                result.append(true)
            } else {
                result.append(false)
            }
        }
        return result
    }

}
