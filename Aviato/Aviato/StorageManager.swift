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
        //        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        //        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.userName))= %@", username)
        //        guard let object = try? self.persistentContainer.viewContext.fetch(fetchRequest).first else { return nil }
        
        let context = self.persistentContainer.viewContext
        let user: UserViewModel?
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            for usr in users {
                if usr.userName == username {
                    user = UserViewModel(userID: usr.userID!, username: usr.userName!, password: usr.password!)
                    return user
                    
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
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
    
    func AddFlyght(flyght: FlyghtViewModel) {
        self.persistentContainer.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.userID)) = '\(flyght.holder)'")
                guard let user = try context.fetch(fetchRequest).first else { return }
                let object = Flyght(context: context)
                object.flyghtID = flyght.flyghtID
                object.flyghtNumber = flyght.flyghtNumber
                object.user = user
                try context.save()
                //DispatchQueue.main.async { completion(nil) }
            } catch {
                //DispatchQueue.main.async { completion(NoteException.saveFailed) }
            }
        }
    }
    
    func removeFlyght(flyght: FlyghtViewModel)  {
        
    }
}
