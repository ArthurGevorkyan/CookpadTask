//
//  ErrorCode.swift
//  CookpadTask
//
//  Created by Exporent on 31.01.22.
//

import Foundation

enum ErrorCode: Int {
    case invalidAppWindowState = 99
    case invalidRequestURL = 100
    case invalidResponse = 101
    case responseDataMissing = 102
    case invalidPersistentContainerState = 112
    case decoderContextMissing = 123
    case dataPersistenceFailure = 133
    case viewModelLoadingFailure = 300
}
