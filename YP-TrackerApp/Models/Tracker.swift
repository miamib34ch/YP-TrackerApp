//
//  Tracker.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 02.05.2023.
//

//сущность для хранения информации про трекер (для «Привычки» или «Нерегулярного события»)

import UIKit

struct Tracker {
    
    let id: String
    let name: String
    let color: UIColor
    let emoji: String
    let shedule: [Bool]
    
}
