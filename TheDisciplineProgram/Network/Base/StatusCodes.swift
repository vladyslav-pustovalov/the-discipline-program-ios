//
//  StatusCodes.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 20/06/2025.
//

/// 1xx Informational
enum InformationalStatus: Int, Error {
    case continueStatus = 100
    case switchingProtocols = 101
    case processing = 102
    
    var description: String { return "" }
    var code: Int { return self.rawValue }
}

/// 2xx Success
enum SuccessStatus: Int, Error {
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case iMUsed = 226
    
    var description: String { return "\(self)" }
    var code: Int { return self.rawValue }
}

/// 3xx Redirection
enum RedirectionStatus: Int, Error {
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case unused = 306
    case temporaryRedirect = 307
    case permanentRedirect = 308
    
    var description: String { return "\(self)" }
    var code: Int { return self.rawValue }
}

/// 4xx Client Error
enum ClientErrorStatus: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case requestEntityTooLarge = 413
    case requestURITooLong = 414
    case unsupportedMediaType = 415
    case requestedRangeNotSatisfiable = 416
    case expectationFailed = 417
    case iAmReapot = 418
    case enhanceYourCalm = 420
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case reservedForWebDAV = 425
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case noResponse = 444
    case retryWith = 449
    case blockedbyWindowsParentalControls = 450
    case unavailableForLegalReasons = 451
    case clientClosedRequest = 499
    
    var description: String { return "\(self)" }
    var code: Int { return self.rawValue }
}

/// 5xx Server Error
enum ServerErrorStatus: Int, Error {
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case bandwidthLimitExceeded = 509
    case notExtended = 510
    case networkAuthenticationRequired = 511
    case networkReadTimeoutError = 598
    case networkConnectTimeoutError = 599
    
    var description: String { return "\(self)" }
    var code: Int { return self.rawValue }
}

/// Internal Status
enum InternalStatus: Int, Error {
    case internetAccessError = 1
    case unknown = 2
    case invalidUrl = 3
    case noData = 4
    case unableToDecode = 5
    case noPermission = 6
    
    var description: String { return "\(self)" }
    
    var code: Int { return self.rawValue }
}
