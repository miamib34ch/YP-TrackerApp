//
//  TrackerRecordStore.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 11.07.2023.
//

import Foundation
import CoreData

final class TrackerRecordStore {

    func takeAllRecords() -> Set<TrackerRecord> {
        var result = Set<TrackerRecord>()

        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false

        var trackerRecordsCoreData = [TrackerRecordCoreData]()
        do {
            trackerRecordsCoreData = try CoreDataStack.context.fetch(request)
        } catch let error {
            print("TrackerRecordStore.takeAllRecords: \(error)")
            return []
        }

        for trackerRecordCoreData in trackerRecordsCoreData {
            result.insert(TrackerRecord(idTracker: trackerRecordCoreData.idTracker ?? UUID(), date: trackerRecordCoreData.date ?? Date()))
        }

        return result
    }

    func createTrackerRecord(id: UUID, date: Date) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: CoreDataStack.context)
        trackerRecordCoreData.idTracker = id
        trackerRecordCoreData.date = date
        do {
            try CoreDataStack.saveContext()
        } catch {
            print("TrackerRecordStore.createTrackerRecord: \(error)")
        }
    }

    func deleteTrackerRecord(id: UUID, date: Date) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                    #keyPath(TrackerRecordCoreData.idTracker),
                                    id.uuidString,
                                    #keyPath(TrackerRecordCoreData.date),
                                    date as CVarArg)
        request.predicate = predicate
        do {
            let result = try CoreDataStack.context.fetch(request)
            guard let trackerRecord = result.first else { return }
            CoreDataStack.context.delete(trackerRecord)
            try CoreDataStack.saveContext()
        } catch {
            print("TrackerRecordStore.deleteTrackerRecord: \(error)")
            return
        }
    }

}
