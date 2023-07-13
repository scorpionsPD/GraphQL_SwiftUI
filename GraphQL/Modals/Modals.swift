//
//  Modals.swift
//  GraphQL
//
//  Created by Pradeep Dahiya on 13/07/2023.
//

import Foundation

struct Product: Identifiable {
    let id: Int
    let sku: String
    let name: String
    let price: Double
    let imageURL: URL
}

// MARK: - Response
struct Response: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let products: Products
}

// MARK: - Products
struct Products: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: Int
    let sku, name: String
    let price: Price
    let image: ImageURL
}

// MARK: - Image
struct ImageURL: Codable {
    let url: String
}

// MARK: - Price
struct Price: Codable {
    let regularPrice: RegularPrice
}

// MARK: - RegularPrice
struct RegularPrice: Codable {
    let amount: Amount
}

// MARK: - Amount
struct Amount: Codable {
    let currency: Currency
    let value: Double
}

enum Currency: String, Codable {
    case gbp = "GBP"
}
