//
//  KeyChainManager.swift
//  Aviato
//
//  Created by Vlad on 17.07.2021.
//

import Foundation

class KeyChainManager {
    
    static func saveSessionToKeyChain(userID: String) {
        let id = Data("\(userID)".utf8)
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to save in Keychain
            //Сервис, к которому относится запись keyChain, в данном случае сервис = приложение
            kSecAttrService as String: "Aviato" as AnyObject,
            //Учетная запись = ключ, по которому ищется запись, в нашем случае - сессия пользователя
            kSecAttrAccount as String: "UserSession" as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            // kSecValueData - значение ключа, UUID пользователя
            kSecValueData as String: id as AnyObject
        ]
        //метод сохранения в keychain, если статус 0 - все ок
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )
        
        print(status)
    }
    
    static func readUserSession() -> String? {
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            //Сервис, к которому относится запись keyChain, в данном случае сервис = приложение
            kSecAttrService as String: "Aviato" as AnyObject,
            //Учетная запись = ключ, по которому ищется запись, в нашем случае - сессия пользователя
            kSecAttrAccount as String: "UserSession" as AnyObject,
            //тип записи(контейнера keychain) - пароль
            kSecClass as String: kSecClassGenericPassword,
            // kSecMatchLimitOne indicates keychain should read
            // Возвращается только одно значение
            kSecMatchLimit as String: kSecMatchLimitOne,
            
            // kSecReturnData is set to kCFBooleanTrue in order
            // to retrieve the data for the item
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        // SecItemCopyMatching will attempt to copy the item
        // identified by query to the reference itemCopy
        var itemCopy: AnyObject?
        // получение записи из keychain, если статус 0 - все ок
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )
        print(status)
        guard let session = itemCopy as? Data,  let userID = String(data: session, encoding: .utf8) else {
            return nil
        }
        
        return userID
    }
    
    static func deleteUserSession() {
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to delete in Keychain
            //Сервис, к которому относится запись keyChain, в данном случае сервис = приложение
            kSecAttrService as String: "Aviato" as AnyObject,
            //Учетная запись = ключ, по которому ищется запись, в нашем случае - сессия пользователя
            kSecAttrAccount as String: "UserSession" as AnyObject,
            //тип записи(контейнера keychain) - пароль
            kSecClass as String: kSecClassGenericPassword
        ]
        //удаляем искомый ключ из keychain
        let status = SecItemDelete(query as CFDictionary)
        print(status)
    }
    
}
