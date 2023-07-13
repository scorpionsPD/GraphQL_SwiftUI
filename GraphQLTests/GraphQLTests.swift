//
//  GraphQLTests.swift
//  GraphQLTests
//
//  Created by Pradeep Dahiya on 11/07/2023.
//

import XCTest
@testable import GraphQL

class ContentViewTests: XCTestCase {
    func testFetchProductsSuccess() {
        let contentView = ContentView()
        
        // Access the view's @StateObject property
        let viewModel = ProductViewModel()
        
        // Verify that the products list is initially empty
        XCTAssertTrue(viewModel.products.isEmpty, "Products list should be empty")
        
        // Simulate the onAppear event to trigger data fetching
        contentView.onAppear()
        
        // Assert that the products list is not empty after fetching
        XCTAssertNotNil(viewModel.products)
    }
    
    func testFetchProductsFailure() {
        let viewModel = ProductViewModel(fileURL: URL(fileURLWithPath: "invalid/path.json"))
        let contentView = ContentView()
        
        // Assign the created viewModel instance to the @StateObject property
        //contentView.viewModel = viewModel
        
        // Verify that the products list is initially empty
        XCTAssertTrue(viewModel.products.isEmpty, "Products list should be empty")
        
        // Simulate the onAppear event to trigger data fetching
        contentView.onAppear()
        
        // Assert that the products list remains empty after a failed fetch
        XCTAssertTrue(viewModel.products.isEmpty, "Products list should be empty")
    }
}

class ProductViewModelTests: XCTestCase {
    func testFetchProductsSuccess() {
        let viewModel = ProductViewModel()
        let expectation = XCTestExpectation(description: "Fetch products")
        
        viewModel.fetchProducts { result in
            switch result {
            case .success:
                // Assert that the products array is not empty after fetching
                XCTAssertFalse(viewModel.products.isEmpty, "Failed to fetch products")
            case .failure(let error):
                XCTFail("Failed to fetch products with error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchProductsFailure() {
        let viewModel = ProductViewModel(fileURL: URL(fileURLWithPath: "invalid/path.json"))
        let expectation = XCTestExpectation(description: "Fetch products")
        
        viewModel.fetchProducts { result in
            switch result {
            case .success:
                XCTFail("Fetching products succeeded unexpectedly")
            case .failure:
                // Assert that the products array is empty after a failed fetch
                XCTAssertTrue(viewModel.products.isEmpty, "Products array should be empty")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}

class ImageLoaderTests: XCTestCase {
    func testImageLoading() {
        let imageURL = URL(string: "https://www.example.com/image.jpg")!
        let imageLoader = ImageLoader(url: imageURL)
        
        // Add your assertions here to verify image loading behavior
        // For example, you can assert that the image property is not nil after a certain amount of time
        
        // Wait for some time to allow the image to load
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertNotNil(imageLoader.image, "Failed to load image")
        }
    }
}

