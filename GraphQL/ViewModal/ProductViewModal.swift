//
//  ProductViewModal.swift
//  GraphQL
//
//  Created by Pradeep Dahiya on 13/07/2023.
//

import Foundation
import Apollo

class ProductViewModel: ObservableObject {
    // MARK: - Properties
    
    // Published property to update the UI when products are fetched
    @Published var products: [Product] = []
    
    // URL of the local JSON file for initial data
    private let fileURL: URL
    
    // Apollo Client to make GraphQL API requests
    private let apollo = ApolloClient(url: URL(string:"https://www.greenbowsports.com/graphql")!)
    
    // Flag to check if an API request is already in progress
    private var isFetching = false
    
    // Published property to show/hide the error alert
    @Published var showErrorAlert = false
    
    // Error message to be displayed in the alert
    @Published var errorMessage = ""
    
    // Cached products to avoid unnecessary API calls
    private var cachedProducts: [Product] = []
    
    // MARK: - Initialization
    
    init(fileURL: URL = Bundle.main.url(forResource: "products", withExtension: "json")!) {
        self.fileURL = fileURL
    }
    
    // MARK: - Fetch Products
    
    // Fetch products from the GraphQL API or use cached data
    func fetchCategoryProducts(completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Avoid multiple API calls by checking isFetching flag
        guard !isFetching else {
            return
        }
        isFetching = true
        
        let query = ProductQueryQuery()
        apollo.fetch(query: query) { [weak self] result in
            self?.isFetching = false
            switch result {
            case .success(let graphQLResult):
                // Parse GraphQL data and update products array if successful
                guard let productsData = self?.parseGraphQLData(data: graphQLResult) else {
                    completion(.failure(ProductError.invalidData))
                    return
                }
                self?.products = productsData
                completion(.success(()))
            case .failure(let error):
                // Handle API failure and show alert with error message
                self?.showErrorAlert = true
                self?.errorMessage = "Error fetching category products: \(error.localizedDescription)"
                // Load local products in case of API failure if required
                // self?.loadLocalProducts()
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Local Data
    
    // Load initial data from the local JSON file asynchronously
    private func loadLocalProducts() {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: self?.fileURL ?? URL(fileURLWithPath: "")),
                  let response = try? JSONDecoder().decode(Response.self, from: data) else {
                return
            }
            self?.products = response.data.products.items.map { item in
                Product(
                    id: item.id,
                    sku: item.sku,
                    name: item.name,
                    price: item.price.regularPrice.amount.value,
                    imageURL: URL(string: item.image.url)!
                )
            }
        }
    }
    
    // MARK: - Data Parsing
    
    // Parse GraphQL data and create an array of Product objects
    private func parseGraphQLData(data: GraphQLResult<ProductQueryQuery.Data>?) -> [Product]? {
        guard let products = data?.data?.products?.items else {
            return []
        }
        
        return products.compactMap { item in
            guard let id = item?.id,
                  let sku = item?.sku,
                  let name = item?.name,
                  let priceValue = item?.price?.regularPrice?.amount?.value,
                  let currency = item?.price?.regularPrice?.amount?.currency,
                  let imageUrl = item?.image?.url else {
                return nil
            }
            
            let price = Double(priceValue)
            return Product(id: id, sku: sku, name: name, price: price, imageURL: (URL(string:imageUrl) ?? URL(string: ""))!)
        }
    }
    
    // MARK: - Error Handling
    
    // Define custom ProductError for better error handling
    enum ProductError: Error {
        case invalidData
    }
}
