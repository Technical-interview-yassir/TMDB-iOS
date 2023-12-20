//
//  SecretManager.swift
//  TMDB
//
//  Created by Maxime Bentin on 20.12.23.
//

import Foundation

protocol SecretManagable { func readTMDBAccessToken(file: URL) -> String }

struct SecretManager: SecretManagable {
    func readTMDBAccessToken(file: URL) -> String {
        do {
            let infoPlistData = try Data(contentsOf: file)
            guard
                let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil)
                    as? [String: String], let accessToken = dict["TMDB_accessToken"]
            else { return "" }

            return accessToken
        } catch {
            return ""
        }
    }
}
