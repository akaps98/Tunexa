//
//  SongViewModel.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 13/09/2023.
//

import CoreData

class SongViewModel{
    static let shared = SongViewModel()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
