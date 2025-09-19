//
//  FileModel+Handlers.swift
//  DataStorage
//
//  Created by George Popkich on 13.02.25.
//

import Foundation
import CoreData

extension FileModel {
    
    public var fileId: String {
        get { id ?? UUID().uuidString }
        set { id = newValue }
    }
    
    public var fileDate: Date {
        get { date ?? Date() }
        set { date = newValue }
    }
    
    public var fileIconName: String {
        get { iconName ?? "mainIcon" }
        set { iconName = newValue }
    }
    
    public var fileName: String {
        get { name ?? "Unknown Name" }
        set { name = newValue }
    }
    
    public var fileSize: String {
        get { size ?? " " }
        set { size = newValue }
    }
  
    public var fileType: String {
        get { type ?? "Unknown Type" }
        set { type = newValue }
    }
    
    public var fileUrl: String {
        get { url ?? "" }
        set { url = newValue}
    }
    
    public static func fetch() -> NSFetchRequest<FileModel> {
        let request = NSFetchRequest<FileModel>(entityName: "FileModel")
        
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FileModel.date,
                                                    ascending: false)]
        return request
    }
    
    public static func create(from dto: FileDTOModel,
                       with context: NSManagedObjectContext
    ) {
        let fileModel = FileModel(context: context)
        fileModel.id = dto.id
        fileModel.date = dto.date
        fileModel.iconName = dto.iconName
        fileModel.name = dto.name
        fileModel.size = dto.size
        fileModel.type = dto.type
        fileModel.url = dto.url
        
        context.saveContext()
    }
    
    public static func delete(at offset: IndexSet, for files: [FileModel]) {
        if let first = files.first, let context = first.managedObjectContext {
            offset.map { files[$0] }.forEach(context.delete)
            context.saveContext()
        }
    }
    
    public static func delete(file: FileModel) {
        if let context = file.managedObjectContext {
            context.delete(file)
            context.saveContext()
        }
    }
    
}
