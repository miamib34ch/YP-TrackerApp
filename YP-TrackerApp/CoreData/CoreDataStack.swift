//
//  Store.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 11.07.2023.
//

import Foundation
import CoreData

final class CoreDataStack {

    private static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error)
            } else {
                print(storeDescription)
            }
        })
        return container
    }()

    static let context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    static func saveContext() throws {
        try context.save()
    }

}
