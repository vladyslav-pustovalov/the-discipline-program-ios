//
//  AppLogger.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/07/2025.
//

import os
import Foundation

enum AppLogger {
    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.thedisciplineprogram.the-discipline-program-ios"
    
    static let general = Logger(subsystem: bundleIdentifier, category: "general")
    static let network = Logger(subsystem: bundleIdentifier, category: "network")
    static let error = Logger(subsystem: bundleIdentifier, category: "error")
}

enum Log {
    static func debug(_ message: String, logger: Logger = AppLogger.general) {
        #if DEBUG
        logger.debug("\(message, privacy: .public)")
        #endif
    }
    
    static func info(_ message: String, logger: Logger = AppLogger.general) {
        logger.info("\(message, privacy: .public)")
    }

    static func error(_ message: String, logger: Logger = AppLogger.error) {
        logger.error("\(message, privacy: .public)")
    }
}
