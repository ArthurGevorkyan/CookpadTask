//
//  ErrorReporter.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

import Foundation

protocol ErrorReporter {
    /* Fails fast in DEBUG. In RELEASE mode, fails gracefully */
    func formFatalError(message: String, code: Int) -> Error
    /* Produces a human-readable error with the given parameters */
    func formReportableError(message: String, code: Int) -> Error
}

// MARK: - Default implementation
extension ErrorReporter {
    func formFatalError(message: String, code: Int) -> Error {
#if DEBUG
        fatalError(message)
#else
        let errorInfo = [NSDebugDescriptionErrorKey : message]
        let error = NSError(domain: "\(type(of: self))", code: code, userInfo: errorInfo)
        return error
#endif
    }
    
    func formReportableError(message: String, code: Int) -> Error {
        let errorInfo = [NSDebugDescriptionErrorKey : message]
        let error = NSError(domain: "\(type(of: self))", code: code, userInfo: errorInfo)
        return error
    }
}

