//
//  KeychainService.swift
//  FootballApp
//
//  Created by Андрей on 15.12.2021.
//

import Foundation
import Security
import UIKit

class KeychainService : NSObject {
    
    static func generateQuery(key: String, data: Data) -> [String : Any] {
        return [kSecClass as String: kSecClassGenericPassword as String,
                kSecAttrAccount as String: key,
                kSecValueData as String: data] as [String : Any]
    }
    
    static func saveToKeychainService(key: String, data: Data) -> OSStatus {
        let query = generateQuery(key: key, data: data)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    static func getDataFromKeychainByKey(key: String) -> Data? {
        let query = [kSecClass as String: kSecClassGenericPassword as String,
                     kSecAttrAccount as String: key,
                     kSecReturnData as String: kCFBooleanTrue!,
                     kSecMatchLimit as String: kSecMatchLimitOne] as [String : Any]
        
        var dataReference : AnyObject? = nil
        let status : OSStatus = SecItemCopyMatching(query as CFDictionary, &dataReference)
        if status == noErr {
            return dataReference as! Data?
        }
        
        return nil
    }
    
    static func deleteFromKeyhainByKey(key: String) {
        let maybeData = self.getDataFromKeychainByKey(key: key)
        
        if let data = maybeData {
            let query = generateQuery(key: key, data: data)
            
            SecItemDelete(query as CFDictionary)
        }
    }
}
