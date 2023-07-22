//
//  TrackerStore.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 11.07.2023.
//

import UIKit
import CoreData

final class TrackerStore {

    func createTracker(tracker: Tracker, category: TrackerCategory, categoryStore: TrackerCategoryStore) {
        let trackerCoreData = TrackerCoreData(context: CoreDataStack.context)
        trackerCoreData.idTracker = tracker.idTracker
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = UIColorMarshalling().hexString(from: tracker.color)
        trackerCoreData.schedule =  tracker.shedule.boolString()
        trackerCoreData.fixed = tracker.fixed
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
    
    func findTracker(id: UUID) -> Tracker? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.idTracker), id.uuidString)
        request.predicate = predicate
        do {
            let result = try CoreDataStack.context.fetch(request)
            guard let tracker = result.first,
                  let idTracker = tracker.idTracker,
                  let name = tracker.name,
                  let color = tracker.color,
                  let emoji = tracker.emoji,
                  let schedule = tracker.schedule else { return nil }
            return Tracker(idTracker: idTracker, name: name, color: UIColorMarshalling().color(from: color), emoji: emoji, shedule: schedule.boolArray(), fixed: tracker.fixed)
        } catch {
            print("TrackerStore.findTracker: \(error)")
            return nil
        }
    }
    
    func editTracker(tracker: Tracker, oldCategory: TrackerCategory, newCategory: TrackerCategory, categoryStore: TrackerCategoryStore) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.idTracker), tracker.idTracker.uuidString)
        request.predicate = predicate
        do {
            let result = try CoreDataStack.context.fetch(request)
            guard let trackerFounded = result.first else { return }
            trackerFounded.name = tracker.name
            trackerFounded.emoji = tracker.emoji
            trackerFounded.color = UIColorMarshalling().hexString(from: tracker.color)
            trackerFounded.schedule =  tracker.shedule.boolString()
            trackerFounded.fixed = tracker.fixed
            try CoreDataStack.saveContext()
            
            // Меняем категорию
            categoryStore.deleteTrackerFromCategory(tracker: trackerFounded, category: oldCategory)
            categoryStore.addTrackerToCategory(tracker: trackerFounded, category: newCategory)
        } catch {
            print("TrackerStore.editTracker: \(error)")
        }
    }
    
    func editFixedStateTracker(id: UUID, state: Bool) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.idTracker), id.uuidString)
        request.predicate = predicate
        do {
            let result = try CoreDataStack.context.fetch(request)
            guard let tracker = result.first else { return }
            tracker.fixed = state
            try CoreDataStack.saveContext()
        } catch {
            print("TrackerStore.editFixedStateTracker: \(error)")
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
