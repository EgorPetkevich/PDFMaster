//
//  NSManagedObjectContext+Save.swift
//  DataStorage
//
//  Created by George Popkich on 13.02.25.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    public func saveContext() {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                let nsError = error as NSError
                fatalError("[Error] \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}
