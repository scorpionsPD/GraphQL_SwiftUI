//
//  ContentView.swift
//  GraphQL
//
//  Created by Pradeep Dahiya on 11/07/2023.
//

import SwiftUI
import Foundation

struct ContentView: View {
    // Create an instance of the ProductViewModel using @StateObject
    @StateObject private var viewModel = ProductViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.products) { product in
                // Navigate to the ProductDetailView when tapped
                NavigationLink(destination: ProductDetailView(product: product)) {
                    HStack {
                        // Display the product image using AsyncImage
                        AsyncImage(url: product.imageURL) {
                            // Placeholder view while loading
                            Color.gray
                                .frame(width: 50, height: 50)
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            // Display the product name
                            Text(product.name)
                                .font(.headline)
                            
                            // Display the product price
                            Text("Price: \(product.price)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Products") // Set the navigation title
        }
        .onAppear {
            viewModel.fetchProducts { result in
                switch result {
                case .success:
                    // Data fetched successfully
                    break
                case .failure(let error):
                    // Handle error
                    print("Error fetching products: \(error)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
