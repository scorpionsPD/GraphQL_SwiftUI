//
//  ProductDetailView.swift
//  GraphQL
//
//  Created by Pradeep Dahiya on 13/07/2023.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        VStack {
            // Product Name
            Text(product.name)
                .font(.headline)
            // Product Image
            AsyncImage(url: product.imageURL) {
                // Placeholder view
                Color.gray
                    .frame(width: 200, height: 200)
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
            
            // Product Details
            Text("ID: \(product.id)")
                .font(.subheadline)
            Text("SKU: \(product.sku)")
                .font(.subheadline)
            Text("Price: \(product.price)")
                .font(.subheadline)
            
            Spacer() // Add some spacing at the bottom
        }
        .padding()
    }
}

