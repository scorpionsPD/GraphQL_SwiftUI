//
//  Utills.swift
//  GraphQL
//
//  Created by Pradeep Dahiya on 13/07/2023.
//

import Foundation
import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    
    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    init(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
