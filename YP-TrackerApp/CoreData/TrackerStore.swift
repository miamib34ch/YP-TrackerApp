//
//  TrackerStore.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 11.07.2023.
//

import Foundation
import CoreData

final class TrackerStore {

    func createTracker(tracker: Tracker, category: TrackerCategory, categoryStore: TrackerCategoryStore) {
        let trackerCoreData = TrackerCoreData(context: CoreDataStack.context)
        trackerCoreData.idTracker = tracker.idTracker
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = UIColorMarshalling().hexString(from: tracker.color)
        trackerCoreData.schedule =  tracker.shedule.boolString()
        do {
            try CoreDataStack.saveContext()
        } catch {
            print("TrackerStore.createTracker: \(error)")
        }
        categoryStore.addTrackerToCategory(tracker: trackerCoreData, category: category)
    }

    func deleteTracker(id: UUID) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.idTracker), id.uuidString)
        request.predicate = predicate
        do {
            let result = try CoreDataStack.context.fetch(request)
            guard let tracker = result.first else { return }
            CoreDataStack.context.delete(tracker)
            try CoreDataStack.saveContext()
        } catch {
            print("TrackerStore.deleteTracker: \(error)")
            return
        }
    }

}

private extension [Bool] {
    
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
