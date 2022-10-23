//
//  StorageManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation
import CoreData
import UIKit

protocol IStorageManager {
    func loadUser(email: String?, userID: String?) -> UserViewModel?
    func addUser(user: UserViewModel)
    func deleteUser(userID: String)
    func updateUser(userID: String, userInfo: UserViewModel)
    func addFlyght(flyght: FlyghtViewModel)
    func removeFlyght(flyghtID: String)
    func updateFlyght(flyghtID: String, flyght: FlyghtViewModel)
    func getFlyghts(userID: String) -> [FlyghtViewModel]?
    func getFlyght(flyghtID: String) -> FlyghtViewModel?
    func flyghtsCount(userID: String) -> Int
    func contains(userID: String, flyghtNumber: String) -> Bool
    func loadImage(fileName: String) -> UIImage?
    @discardableResult func saveImage(image: UIImage, fileName: String) -> String
    func removeImage(fileName: String)
}

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
    
    func loadUser(email: String?, userID: String?) -> UserViewModel? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        if let email = email {
            fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.email)) = %@", email)
        } else if let userID = userID {
            fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.userID)) = %@", "\(userID)")
        }
        guard let object = try? persistentContainer.viewContext.fetch(fetchRequest).first else { return nil }
        let user: UserViewModel = UserViewModel(userID: object.userID ?? "", password: object.password ?? "empty", birthDate: object.birthDate ?? Date(), email: object.email ?? "empty", name: object.name ?? "empty")
        return user
    }
    
    func addUser(user: UserViewModel) {
        self.persistentContainer.performBackgroundTask { context in
            let object = User(context: context)
            object.userID = user.userID
            object.password = user.password
            object.email = user.email
            object.birthDate = user.birthDate
            object.name = user.name
            try? context.save()
        }
    }
    
    func deleteUser(userID: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.userID)) = %@", "\(userID)")
        if let object = try? context.fetch(fetchRequest).first {
            removeImage(fileName: userID)
            context.delete(object)
        }
        try? context.save()
    }
    
    func updateUser(userID: String, userInfo: UserViewModel) {
        let context = persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userID = %@", "\(userID)")
            if let foundUser = try? self.persistentContainer.viewContext.fetch(fetchRequest).first {
                foundUser.setValue(userInfo.birthDate, forKey: "birthDate")
                foundUser.setValue(userInfo.name, forKey: "name")
                foundUser.setValue(userInfo.email, forKey: "email")
            }
            try context.save()
        } catch {
            print("Something wrong in updateUser \(error)")
        }
    }
    
    @discardableResult func saveImage(image: UIImage, fileName: String) -> String{
        if let data = image.pngData() {
            let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let url = path.appendingPathComponent(fileName).appendingPathExtension("png")
            do {
                try data.write(to: url)
                return "\(url)"
            } catch {
                print(error)
            }
        }
        return ""
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let url = path.appendingPathComponent(fileName).appendingPathExtension("png")
        guard let imageData = try? Data(contentsOf: url) else {
            return nil
        }
        let image = UIImage.init(data: imageData)
        return image
    }
    
    func removeImage(fileName: String) {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let url = path.appendingPathComponent(fileName).appendingPathExtension("png")
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
    }
    
    func addFlyght(flyght: FlyghtViewModel) {
        let context = persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.userID)) = '\(flyght.holder)'")
            guard let user = try context.fetch(fetchRequest).first else { return }
            let object = Flyght(context: context)
            object.flyghtID = flyght.flyghtID
            object.flyghtNumber = flyght.flyghtNumber
            object.status = flyght.status
            object.aircraft = flyght.aircraft
            object.airline = flyght.airline
            object.arrivalAirport = flyght.arrivalAirport
            object.arrivalTime = flyght.arrivalDate
            object.departureTime = flyght.departureDate
            object.departureAirport = flyght.departureAirport
            object.user = user
            object.lastModified = Date()
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func getFlyghts(userID: String) -> [FlyghtViewModel]? {
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY user.userID = %@", "\(userID)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone.current
        
        let flyghts = try? persistentContainer.viewContext.fetch(fetchRequest).compactMap { FlyghtViewModel(holder: userID, flyghtID: $0.flyghtID ?? "", flyghtNumber: $0.flyghtNumber ?? "", departureAirport: $0.departureAirport ?? "", arrivalAirport: $0.arrivalAirport ?? "", departureDate: $0.departureTime ?? Date(), arrivalDate: $0.arrivalTime ?? Date(), aircraft: $0.aircraft ?? "", airline: $0.airline ?? "", status: $0.status ?? "", departureDateLocal: dateFormatter.string(from: $0.departureTime ?? Date()) , arrivalDateLocal: dateFormatter.string(from: $0.arrivalTime ?? Date()))
        }
        return flyghts
    }
    
    func flyghtsCount(userID: String) -> Int {
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY user.userID = %@", "\(userID)")
        let flyghtsCount = try? persistentContainer.viewContext.fetch(fetchRequest).count
        return flyghtsCount ?? 0
    }
    
    func getFlyght(flyghtID: String) -> FlyghtViewModel? {
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone.current
        fetchRequest.predicate = NSPredicate(format: "flyghtID = %@", "\(flyghtID)")
        if let flyghts = try? persistentContainer.viewContext.fetch(fetchRequest).first {
            let flyghtViewModel = FlyghtViewModel(holder: "", flyghtID: flyghtID, flyghtNumber: (flyghts.flyghtNumber!), departureAirport: flyghts.departureAirport!, arrivalAirport: flyghts.arrivalAirport!, departureDate: flyghts.departureTime!, arrivalDate: flyghts.arrivalTime!, aircraft: flyghts.aircraft!, airline: flyghts.airline!, status: flyghts.status!, departureDateLocal: dateFormatter.string(from: flyghts.departureTime!), arrivalDateLocal: dateFormatter.string(from: flyghts.arrivalTime!))
            return flyghtViewModel
        }
        return nil
    }
    
    func updateFlyght(flyghtID: String, flyght: FlyghtViewModel) {
        let context = persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "flyghtID = %@", "\(flyghtID)")
            if let foundFlyght = try? persistentContainer.viewContext.fetch(fetchRequest).first {
                foundFlyght.setValue(flyght.airline, forKey: "airline")
                foundFlyght.setValue(flyght.aircraft, forKey: "aircraft")
                foundFlyght.setValue(flyght.arrivalAirport, forKey: "arrivalAirport")
                foundFlyght.setValue(flyght.arrivalDate, forKey: "arrivalTime")
                foundFlyght.setValue(flyght.departureAirport, forKey: "departureAirport")
                foundFlyght.setValue(flyght.departureDate, forKey: "departureTime")
                foundFlyght.setValue(flyght.status, forKey: "status")
                foundFlyght.lastModified = Date()
            }
            try context.save()
        } catch {
            print("Something wrong in updateFlyght \(error)")
        }
    }
    
    func removeFlyght(flyghtID: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Flyght.flyghtID)) = %@", "\(flyghtID)")
        if let object = try? context.fetch(fetchRequest).first {
            removeImage(fileName: flyghtID)
            context.delete(object)
        }
        try? context.save()
    }
    
    func contains(userID: String, flyghtNumber: String) -> Bool {
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user.userID = %@ AND flyghtNumber = %@", argumentArray: [userID, flyghtNumber])
        if (try? persistentContainer.viewContext.fetch(fetchRequest).first) != nil {
            return true
        }
        return false
    }
}
