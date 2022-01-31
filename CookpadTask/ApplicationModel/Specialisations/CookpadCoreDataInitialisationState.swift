//
//  CookpadCoreDataInitialisationState.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 28.01.22.
//

enum CookpadCoreDataInitialisationState {
    case unknown
    case successful
    case pending
    case failed(error: Error)
}
