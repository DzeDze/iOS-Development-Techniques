//
//  Constants.swift
//  TaskGroupSample
//
//  Created by Vince P. Nguyen on 2024-10-12.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case encodingError
    case invalidResponse
}

struct Constants {
    static func randomImageUrl() -> URL? {
        return URL(string: "https://picsum.photos/200?uuid=\(UUID().uuidString)")
    }
    static let randomQuoteUrl: URL? = URL(string: "https://zenquotes.io/api/random")
}
