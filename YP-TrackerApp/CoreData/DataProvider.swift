//
//  DataProvider.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 11.07.2023.
//

import Foundation
import CoreData

protocol DataProviderDelegate {
    func updateCollection()
    func updateVisibleCategories()
}

final class DataProvider: NSObject {

    static let shared = DataProvider()

    var delegate: DataProviderDelegate?

    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()

    private var trackerFetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCoreData.name), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: CoreDataStack.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    private override init() {
        super.init()
        
        trackerFetchedResultsController.delegate = self
    }

    func takeCategories() -> [TrackerCategory] {
        return trackerCategoryStore.takeAllCategories()
    }

    func addTracker(tracker: Tracker, category: TrackerCategory) {
        trackerStore.createTracker(tracker: tracker, category: category, categoryStore: trackerCategoryStore)
    }

    func deleteCategory(categoryName: String) {
        trackerCategoryStore.deleteTrackerCategory(name: categoryName)
    }

    func editCategory(categoryName: String, newCategoryName: String) {
        trackerCategoryStore.editTrackerCategory(name: categoryName, newName: newCategoryName)
    }

    func createRecord(id: UUID, date: Date) {
        trackerRecordStore.createTrackerRecord(id: id, date: date)
    }

    func deleteRecord(id: UUID, date: Date) {
        trackerRecordStore.deleteTrackerRecord(id: id, date: date)
    }

    func takeRecords() -> Set<TrackerRecord> {
        return trackerRecordStore.takeAllRecords()
    }
    
}

extension DataProvider: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateVisibleCategories()
        delegate?.updateCollection()
    }

}
