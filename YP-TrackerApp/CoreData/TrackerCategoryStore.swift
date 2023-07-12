//
//  TrackerCategoryStore.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 11.07.2023.
//

import Foundation
import CoreData
import UIKit

final class TrackerCategoryStore {

    func takeAllCategories() -> [TrackerCategory] {
        var result = [TrackerCategory]()

        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false

        var trackerCategoriesCoreData = [TrackerCategoryCoreData]()
        do {
            trackerCategoriesCoreData = try CoreDataStack.context.fetch(request)
        } catch let error {
            print("TrackerCategoryStore.takeAllCategories: \(error)")
            return []
        }

        for categoryCoreData in trackerCategoriesCoreData {
            var trackers = [Tracker]()
            if let trackersCoreData = categoryCoreData.trackers?.allObjects as? [TrackerCoreData] {
                for trackerCoreData in trackersCoreData {
                    if let idTracker = trackerCoreData.idTracker,
                       let name = trackerCoreData.name,
                       let color = trackerCoreData.color,
                       let emoji = trackerCoreData.emoji,
                       let shedule = trackerCoreData.schedule {
                        trackers.append(Tracker(idTracker: idTracker,
                                                name: name,
                                                color: UIColorMarshalling().color(from: color),
                                                emoji: emoji,
                                                shedule: shedule.boolArray()))
                    }
                }
            }
            if let name = categoryCoreData.name {
                trackers.sort(by: { $0.name > $1.name })
                result.append(TrackerCategory(name: name, trackers: trackers))
            }
            trackers = []
        }
        return result
    }

    func addTrackerToCategory(tracker: TrackerCoreData, category: TrackerCategory) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false

        let predicat = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), category.name)
        request.predicate = predicat

        var trackerCategoriesCoreData = [TrackerCategoryCoreData]()
        do {
            trackerCategoriesCoreData = try CoreDataStack.context.fetch(request)
        } catch let error {
            print("TrackerCategoryStore.addTrackerToCategory: \(error)")
            return
        }

        if trackerCategoriesCoreData.count == 0 {
            // Создаём новую
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: CoreDataStack.context)
            trackerCategoryCoreData.name = category.name
            do {
                try CoreDataStack.saveContext()
            } catch {
                print("TrackerCategoryStore.addTrackerToCategory: save context - \(error)")
            }
            trackerCategoryCoreData.addToTrackers(tracker)
        } else {
            // Добавляем трекер
            trackerCategoriesCoreData.first!.addToTrackers(tracker)
        }

        do {
            try CoreDataStack.saveContext()
        } catch {
            print("TrackerCategoryStore.addTrackerToCategory: save context - \(error)")
        }
    }

    func deleteTrackerCategory(name: String) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), name)
        request.predicate = predicate
        do {
            let result = try CoreDataStack.context.fetch(request)
            guard let category = result.first else { return }
            CoreDataStack.context.delete(category) // Трекеры удалятся каскадно
            try CoreDataStack.saveContext()
        } catch {
            print("TrackerCategoryStore.deleteTrackerCategory: \(error)")
            return
        }
    }

    func editTrackerCategory(name: String, newName: String) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), name)
        request.predicate = predicate
        do {
            let result = try CoreDataStack.context.fetch(request)
            guard let category = result.first else { return }
            category.name = newName
            try CoreDataStack.saveContext()
        } catch {
            print("TrackerCategoryStore.editTrackerCategory: \(error)")
            return
        }
    }

}
