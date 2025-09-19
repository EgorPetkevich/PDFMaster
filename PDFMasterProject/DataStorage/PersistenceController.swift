//
//  PersistenceController.swift
//  DataStorage
//
//  Created by George Popkich on 13.02.25.
//

import CoreData
import CloudKit

import CoreData

public struct PersistenceController {
    public static let shared = PersistenceController()

    public static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = FileModel(context: viewContext)
            newItem.date = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    public let container: NSPersistentContainer

    public init(inMemory: Bool = false) {
        guard
            let modelURL = Bundle(identifier: "com.app..DataStorage")?
                .url(forResource: "FilesDataBase",
                     withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to load Core Data model from DataStorage bundle")
        }

        container = NSPersistentContainer(name: "FilesDataBase", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
