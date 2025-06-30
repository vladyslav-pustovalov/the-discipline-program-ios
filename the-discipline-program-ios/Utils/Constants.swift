//
//  Constants.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 18/06/2025.
//

import Foundation

enum Constants {
    
    enum API {
        static let baseURL = "http://127.0.0.1:8080"
        static let basePath = "/api"
        static let versionAPI = "/v1"
    }
    
    enum HTTPMethods {
        static let get = "GET"
        static let post = "POST"
        static let put = "PUT"
        static let patch = "PATCH"
        static let delete = "DELETE"
    }
    
    enum Formatter {
        static var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }
    }
    
    enum Defaults {
        static let accessToken = "AccessToken"
        static let userId = "UserID"
    }
    
    enum Bundle {
        static let id = "me.vladpustovalov.the-discipline-program-ios"
        static let tokenKey = "accessToken"
    }
}

