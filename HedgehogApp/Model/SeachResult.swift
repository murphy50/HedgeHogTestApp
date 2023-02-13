//
//  ImageResult.swift
//  HedgehogTestApp
//
//  Created by murphy on 07.02.2023.
//

import Foundation

import Foundation

// MARK: - ResponseData
struct ResponseData: Codable {
    let searchMetadata: SearchMetadata
    let searchParameters: SearchParameters
    let searchInformation: SearchInformation
    let suggestedSearches: [SuggestedSearch]
    let imagesData: [ImageData]

    enum CodingKeys: String, CodingKey {
        case searchMetadata = "search_metadata"
        case searchParameters = "search_parameters"
        case searchInformation = "search_information"
        case suggestedSearches = "suggested_searches"
        case imagesData = "images_results"
    }
}

// MARK: - ImagesResult
struct ImageData: Codable {
    let position: Int
    let thumbnail: String
    let source, title: String
    let link: String
    let original: String
    let originalWidth, originalHeight: Int
    let isProduct: Bool
    let inStock: Bool?

    enum CodingKeys: String, CodingKey {
        case position, thumbnail, source, title, link, original
        case originalWidth = "original_width"
        case originalHeight = "original_height"
        case isProduct = "is_product"
        case inStock = "in_stock"
    }
}

// MARK: - SearchInformation
struct SearchInformation: Codable {
    let imageResultsState, queryDisplayed: String
    let menuItems: [MenuItem]

    enum CodingKeys: String, CodingKey {
        case imageResultsState = "image_results_state"
        case queryDisplayed = "query_displayed"
        case menuItems = "menu_items"
    }
}

// MARK: - MenuItem
struct MenuItem: Codable {
    let position: Int
    let title: String
    let link: String?
    let serpapiLink: String?

    enum CodingKeys: String, CodingKey {
        case position, title, link
        case serpapiLink = "serpapi_link"
    }
}

// MARK: - SearchMetadata
struct SearchMetadata: Codable {
    let id, status: String
    let jsonEndpoint: String
    let createdAt, processedAt: String
    let googleURL: String
    let rawHTMLFile: String
    let totalTimeTaken: Double

    enum CodingKeys: String, CodingKey {
        case id, status
        case jsonEndpoint = "json_endpoint"
        case createdAt = "created_at"
        case processedAt = "processed_at"
        case googleURL = "google_url"
        case rawHTMLFile = "raw_html_file"
        case totalTimeTaken = "total_time_taken"
    }
}

// MARK: - SearchParameters
struct SearchParameters: Codable {
    let engine, q, googleDomain, ijn: String
    let device, tbm: String

    enum CodingKeys: String, CodingKey {
        case engine, q
        case googleDomain = "google_domain"
        case ijn, device, tbm
    }
}

// MARK: - SuggestedSearch
struct SuggestedSearch: Codable {
    let name: String
    let link: String
    let chips: String
    let serpapiLink: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case name, link, chips
        case serpapiLink = "serpapi_link"
        case thumbnail
    }
}
