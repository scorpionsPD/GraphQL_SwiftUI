//
//  ProductViewModal.swift
//  GraphQL
//
//  Created by Pradeep Dahiya on 13/07/2023.
//

import Foundation
import Apollo

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    private let fileURL: URL
    private let apollo = ApolloClient(url: URL(string:"https://www.greenbowsports.com/graphql")!)
    
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
    // This function handles the retrieval of products from the GraphQL endpoint using Apollo framework.
    // It returns an array of products fetched from the server, or an empty array if there was an error during the retrieval process.
    /*
    // Funtions needs to be complete after haldle all errors of Apollo framework. it will return same array of products
    func fetchCategoryProducts(completion: @escaping ([Product]?) -> Void) {
        let query = ProductQueryQuery()
        apollo.fetch(query: query) { (result in
                                      switch result {
                                      case .success(let graphQLResult):
     // If successful, return the array of fetched products
       
                                          guard let productsData = graphQLResult else {
                                              completion(nil)
                                              return
                                          }
                                          completion(products)
                                      case .failure(let error):
     // If there was an error, handle the error and return an empty array
                                          print("Error fetching category products: \(error)")
                                          completion(nil)
                                      }
            
        }
    }
     */
}

