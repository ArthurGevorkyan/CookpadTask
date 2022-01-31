//
//  Observable.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 30.01.22.
//

class Observable<T> {
    private var observationHandler: ((T) -> Void)?
    
    var value: T {
        didSet {
            observationHandler?(value)
        }
    }
    
    init(initialValue: T) {
        value = initialValue
    }
    
    func bind(handler: @escaping (T) -> Void) {
        handler(value)
        observationHandler = handler
    }
}
