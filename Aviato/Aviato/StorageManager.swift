//
//  StorageManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation
import CoreData

class StorageManager: IStorageManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Aviato")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func loadUser(username: String) -> UserViewModel? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.userName)) = '\(username)'")
        guard let object = try? self.persistentContainer.viewContext.fetch(fetchRequest).first else { return nil }
        return UserViewModel(username: object.userName!, password: object.password!)
//        return UserViewModel(username: "0", password: "1")
    }
    
    func addUser(user: UserViewModel, completion: @escaping () -> Void) {
            self.persistentContainer.performBackgroundTask { context in
                let object = User(context: context)
                object.userID = user.userID
                object.userName = user.username
                object.password = user.password
                try? context.save()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { completion() })
            }
        }
}
