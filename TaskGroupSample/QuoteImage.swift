//
//  QuoteImage.swift
//  TaskGroupSample
//
//  Created by Vince P. Nguyen on 2024-10-12.
//

import Foundation

struct QuoteImage {
    let quote: Quote
    let imgData: Data
}

struct Quote: Codable {
    let q: String
}
