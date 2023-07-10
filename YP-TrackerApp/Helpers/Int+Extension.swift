//
//  Int+Extension.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 08.07.2023.
//

import Foundation

extension Int {

    var days: String {
        if (11...14).contains(self % 100) {
            return String(self) + " дней"
        }
        switch self % 10 {
        case 1:
            return String(self) + " день"
        case 2, 3, 4:
            return String(self) + " дня"
        default:
            return String(self) + " дней"
        }
    }

}
