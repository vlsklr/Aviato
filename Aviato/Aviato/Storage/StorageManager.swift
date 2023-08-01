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
    func addFlyght(flyght: FlyghtInfoDataModel)
    func removeFlyght(flyghtID: String)
    func updateFlyght(flyghtID: String, flyght: FlyghtInfoDataModel)
    func getFlyghts(userID: String) -> [FlyghtInfoDataModel]?
    func getFlyght(flyghtID: String) -> FlyghtInfoDataModel?
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
    
    @discardableResult func saveImage(image: UIImage, fileName: String) -> String {
        let fileManager = FileManager.default
        let documentsDirectory = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        guard let data = image.pngData(),
              let url = documentsDirectory?.appendingPathComponent(fileName).appendingPathExtension("png") else {
            return ""
        }
        try? data.write(to: url)
        return "\(url)"
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let fileManager = FileManager.default
        let documentsDirectory = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        guard let url = documentsDirectory?.appendingPathComponent(fileName).appendingPathExtension("png"),
              let imageData = try? Data(contentsOf: url) else {
            return nil
        }
        let image = UIImage.init(data: imageData)
        return image
    }
    
    func removeImage(fileName: String) {
        let fileManager = FileManager.default
        let documentsDirectory = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        guard let url = documentsDirectory?.appendingPathComponent(fileName).appendingPathExtension("png") else { return }

        try? fileManager.removeItem(at: url)
    }
    
    func addFlyght(flyght: FlyghtInfoDataModel) {
        let context = persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.userID)) = '\(flyght.holder)'")
            guard let user = try context.fetch(fetchRequest).first else { return }
            let object = Flyght(context: context)
            object.flyghtID = flyght.flyghtID
            object.flyghtNumber = flyght.flyghtNumber
            object.status = flyght.status.rawValue
            object.aircraft = flyght.aircraft
            object.airline = flyght.airline
            object.arrivalAirport = flyght.arrivalAirport
            object.arrivalTime = flyght.arrivalDate
            object.departureTime = flyght.departureDate
            object.departureAirport = flyght.departureAirport
            object.departureCity = flyght.departureCity
            object.arrivalCity = flyght.arrivalCity
            object.user = user
            object.lastModified = Date()
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func getFlyghts(userID: String) -> [FlyghtInfoDataModel]? {
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY user.userID = %@", "\(userID)")
        let flyghts = try? persistentContainer.viewContext.fetch(fetchRequest)
            .compactMap { FlyghtInfoDataModel(holder: userID,
                                              flyghtID: $0.flyghtID ?? "",
                                              flyghtNumber: $0.flyghtNumber ?? "",
                                              departureAirport: $0.departureAirport ?? "",
                                              arrivalAirport: $0.arrivalAirport ?? "",
                                              departureDate: $0.departureTime ?? Date(),
                                              arrivalDate: $0.arrivalTime ?? Date(),
                                              aircraft: $0.aircraft ?? "",
                                              airline: $0.airline ?? "",
                                              status: FlightStatus(rawValue: $0.status ?? "") ?? .unknown,
                                              departureCity: $0.departureCity ?? "",
                                              arrivalCity: $0.arrivalCity ?? "")
            }
        return flyghts
    }
    
    func flyghtsCount(userID: String) -> Int {
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY user.userID = %@", "\(userID)")
        let flyghtsCount = try? persistentContainer.viewContext.fetch(fetchRequest).count
        return flyghtsCount ?? 0
    }
    
    func getFlyght(flyghtID: String) -> FlyghtInfoDataModel? {
        let fetchRequest: NSFetchRequest<Flyght> = Flyght.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "flyghtID = %@", "\(flyghtID)")
        if let flyght = try? persistentContainer.viewContext.fetch(fetchRequest).first {
            let flyghtViewModel = FlyghtInfoDataModel(holder: flyght.user?.userID ?? "",
                                                      flyghtID: flyghtID,
                                                      flyghtNumber: flyght.flyghtNumber ?? "",
                                                      departureAirport: flyght.departureAirport ?? "",
                                                      arrivalAirport: flyght.arrivalAirport ?? "",
                                                      departureDate: flyght.departureTime ?? Date(),
                                                      arrivalDate: flyght.arrivalTime ?? Date(),
                                                      aircraft: flyght.aircraft ?? "",
                                                      airline: flyght.airline ?? "",
                                                      status: FlightStatus(rawValue: flyght.status ?? "") ?? .unknown,
                                                      departureCity: flyght.departureCity ?? "",
                                                      arrivalCity: flyght.arrivalCity ?? "")
            return flyghtViewModel
        }
        return nil
    }
    
    func updateFlyght(flyghtID: String, flyght: FlyghtInfoDataModel) {
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
                foundFlyght.setValue(flyght.status.rawValue, forKey: "status")
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
