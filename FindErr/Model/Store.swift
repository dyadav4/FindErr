//
//  Store.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import Foundation


struct SearchResults: Decodable {
    let businesses: [Store]
}

struct Store: Decodable {
    let id: String?
    let name: String?
    let image: String?
    let coordinates: Coordinate?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image_url"
        case coordinates = "coordinates"
    }
}

struct Coordinate: Decodable {
    let latitude: Double?
    let longitude: Double?
}
