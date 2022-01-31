//
//  Recipe.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

protocol Recipe {
    var id: Int32 { get }
    var title: String { get }
    var story: String { get }
    var imageURL: String? { get }
    var publishedAt: String { get }
    var user: User? { get }
    var ingredients: [String] { get }
    var steps: [Step] { get }
}
