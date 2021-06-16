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
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.userName)) = %@", username)
        guard let object = try? self.persistentContainer.viewContext.fetch(fetchRequest).first else { return nil }
        let user: UserViewModel = UserViewModel(userID: object.userID!, username: object.userName!, password: object.password!)
        return user
    }
    
    func addUser(user: UserViewModel, completion: @escaping () -> Void) {
        self.persistentContainer.performBackgroundTask { context in
            let object = User(context: context)
            object.userID = user.userID
            object.userName = user.username
            object.password = user.password
            try? context.save()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { completion() })
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
                object.aircraft = flyght.aircraft
                object.airline = flyght.airline
                object.arrivalAirport = flyght.arrivalAirport
                object.arrivalTime = flyght.arrivalDate
                object.departureTime = flyght.departureDate
                object.departureAirport = flyght.departureAirport
                object.user = user
                try context.save()
                //DispatchQueue.main.async { completion(nil) }
            } catch {
                //DispatchQueue.main.async { completion(NoteException.saveFailed) }
            }
        }
    }
    
    func getFlyghts(userID: UUID) -> [FlyghtViewModel]? {
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY user.userID = %@", "\(userID)")
        //подумать над форс анвраппом
        let flyghts = try! self.persistentContainer.viewContext.fetch(fetchRequest).compactMap { FlyghtViewModel(holder: userID, flyghtID: $0.flyghtID ?? UUID(), flyghtNumber: $0.flyghtNumber ?? "", departureAirport: $0.departureAirport ?? "", arrivalAirport: $0.arrivalAirport ?? "", departureDate: $0.departureTime ?? "", arrivalDate: $0.arrivalTime ?? "", aircraft: $0.aircraft ?? "", airline: $0.airline ?? "" )
        }
        return flyghts
    }
    
    func getFlyght(flyghtID: UUID) -> FlyghtViewModel? {
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "flyghtID = %@", "\(flyghtID)")
        //        let objct = try! self.persistentContainer.viewContext.fetch(fetchRequest)
        //подумать над форс анвраппом
        if let flyghts = try? self.persistentContainer.viewContext.fetch(fetchRequest).first {
            let flyghtViewModel = FlyghtViewModel(holder: UUID(), flyghtID: flyghtID, flyghtNumber: (flyghts.flyghtNumber!), departureAirport: flyghts.departureAirport!, arrivalAirport: flyghts.arrivalAirport!, departureDate: flyghts.departureTime!, arrivalDate: flyghts.arrivalTime!, aircraft: flyghts.aircraft!, airline: flyghts.airline!)
            return flyghtViewModel
        }
        //
        
        return nil
        
    }
    
//    func removeFlyght(flyghtID: UUID, completion: @escaping () -> Void)  {
    func removeFlyght(flyghtID: UUID) {

        self.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Flyght.flyghtID)) = %@", "\(flyghtID)")
            if let object = try? context.fetch(fetchRequest).first {
                context.delete(object)
            }
            try? context.save()
//            DispatchQueue.main.async { completion() }
        }
    }
}
