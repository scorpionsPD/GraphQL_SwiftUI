//
//  ProductViewModal.swift
//  GraphQL
//
//  Created by Pradeep Dahiya on 13/07/2023.
//

import Foundation

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    private let fileURL: URL
    
    init(fileURL: URL = Bundle.main.url(forResource: "products", withExtension: "json")!) {
        self.fileURL = fileURL
    }
    
    func fetchProducts(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try Data(contentsOf: fileURL)
            let response = try JSONDecoder().decode(Response.self, from: data)
            
            products = response.data.products.items.map { item in
                Product(
                    id: item.id,
                    sku: item.sku,
                    name: item.name,
                    price: item.price.regularPrice.amount.value,
                    imageURL: URL(string: item.image.url)!
                )
            }
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

