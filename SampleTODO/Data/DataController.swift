//
//  DataController.swift
//  SampleTODO
//
//  Created by Никита Куприянов on 22.04.2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {

    let container = NSPersistentContainer(name: "MODEL")

    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Failed to load the data: \(error.localizedDescription)")
            }
        }
    }

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("data saved")
        } catch {
            print("can't save the data")
        }
    }

    func addCase(name: String, when: Date, id: UUID, context: NSManagedObjectContext) {
        let modelCase = ModelCase(context: context)
        modelCase.name = name
        modelCase.done = false 
        modelCase.id = id
        modelCase.when = when
        
        save(context: context)
    }
    
}
