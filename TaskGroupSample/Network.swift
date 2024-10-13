//
//  Network.swift
//  TaskGroupSample
//
//  Created by Vince P. Nguyen on 2024-10-12.
//

import UIKit

class Network {
    
    func getQuoteImageUsingTaskGroup() async throws -> QuoteImage {
        guard let randomImageUrl = Constants.randomImageUrl(),
              let randomQuoteUrl = Constants.randomQuoteUrl else {
            throw NetworkError.invalidUrl
        }
        
        return try await withThrowingTaskGroup(of: (Data, Data).self) { group in
            group.addTask {
                let (randomImageData, _) = try await URLSession.shared.data(from: randomImageUrl)
                let (randomQuoteData, _) = try await URLSession.shared.data(from: randomQuoteUrl)
                return (randomImageData, randomQuoteData)
            }
            
            var resultQuoteImage: QuoteImage?
            
            for try await (randomImageData, randomQuoteData) in group {
                
                let randomQuoteArray = try JSONDecoder().decode([Quote].self, from: randomQuoteData)
                guard let randomQuote = randomQuoteArray.first else {
                    throw NetworkError.encodingError
                }
                resultQuoteImage = QuoteImage(quote: randomQuote, imgData: randomImageData)
            }
            
            if let quoteImage = resultQuoteImage {
                return quoteImage
            } else {
                throw NetworkError.invalidResponse
            }
        }
    }
    
    func getQuoteImageUsingAsyncLet() async throws -> QuoteImage {
        guard let randomImageUrl = Constants.randomImageUrl(),
              let randomQuoteUrl = Constants.randomQuoteUrl else {
            throw NetworkError.invalidUrl
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0 // seconds
        let session = URLSession(configuration: config)
        
        async let randomImageDataTask: Data = {
            [weak self] in
            guard let _ = self else { return Data() }
            let (data, _) = try await session.data(from: randomImageUrl)
            return data
        }()
        
        async let randomQuoteDataTask: Data = {
            [weak self] in
            guard let _ = self else { return Data() }
            let (data, _) = try await session.data(from: randomQuoteUrl)
            return data
        }()
        
        
        let randomImageData = try await randomImageDataTask
        let randomQuoteData = try await randomQuoteDataTask
        
        let quotes = try JSONDecoder().decode([Quote].self, from: randomQuoteData)
        guard let randomQuote = quotes.first else {
            throw NetworkError.encodingError
        }
        
        return QuoteImage(quote: randomQuote, imgData: randomImageData)
    }
    
    func getQuoteImage() async throws {
        let quoteImage = try await getQuoteImageUsingTaskGroup()
        NotificationCenter.default.post(name: .didFetchQuoteImage, object: quoteImage)
    }
    
    func getQuoteImages(amount: Int) async throws  {

        await withThrowingTaskGroup(of: Void.self) { group in
            for _ in 1...amount {
                group.addTask {
                    try await self.getQuoteImage()
                }
            }
        }
    }
}

extension Notification.Name {
    static let didFetchQuoteImage = Notification.Name("didFetchQuoteImage")
}

