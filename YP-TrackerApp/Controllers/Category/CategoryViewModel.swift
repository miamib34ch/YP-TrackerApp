//
//  CategoryViewModel.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 17.07.2023.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    let trackerCategoryStore = TrackerCategoryStore()
    var selectRow: Binding<Void>? = nil
    
    func takeAllCategories() -> [String] {
        var result = [String]()
        for trackerCategory in trackerCategoryStore.takeAllCategories() {
            result.append(trackerCategory.name)
        }
        return result
    }
    
    func deleteCategory(name: String) {
        trackerCategoryStore.deleteTrackerCategory(name: name)
    }

    func didSelectRow() {
        selectRow?(Void())
    }
    
}
