//
//  Crypto.swift
//  Aviato
//
//  Created by user188734 on 7/26/21.
//

import CryptoSwift

class Crypto {
    static func getHash(inputString: String) -> String {
        return inputString.sha256()
    }
}
