//
//  APIRouter.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import Foundation

//Handling the router for the networking layer.
//Used urlsession as this is the one provided the Apple. there are other third parties which can be used such as Alamofire but this is a simple app so decided to stick with URLSession


public enum APIRouter {
    
    case getAllShops(searchterm: String, latitude: Double, longitude: Double)
    case getShop(id: String)
    
    private static let baseURL = "https://api.yelp.com/v3/businesses"
    private static let apiKey = "XHsQ4ptcY0d2GNIM1yXIq87wJaGb30fRQ6prnoQVtdtLvGcaN3VjxEHibcFQdQGx1vZL9w4ZmRgCgbOTr_F2F17hlKEEApzMsKKhHZSPSs7bjfgdWHjt2Rv_0PZTYHYx"
//    static let clientID = "XTR_aCqg864DX9zJvzJb5g"
    
    private enum HTTPMethod {
        case get
        case post
        case put
        case delete
        
        var value: String{
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .delete:
                return "DELETE"
            }
        }
    }
    
    private var method: HTTPMethod {
       switch self {
       case .getAllShops: return .get
       case .getShop:
        return .get
       }
    }
    
    private var path: String {
        switch self {
        case .getAllShops(let searchterm, let latitude, let longitude):
            return "/search?term=\(searchterm)&latitude=\(latitude)&longitude=\(longitude)&radius=8000&sort_by=rating&limit=10"
        case .getShop(let id):
            return "/\(id)"
        }
    }
    
    //getting the final request
    func request() throws -> URLRequest? {
        let urlString = "\(APIRouter.baseURL)\(path)"
        
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = method.value
        request.setValue("Bearer XHsQ4ptcY0d2GNIM1yXIq87wJaGb30fRQ6prnoQVtdtLvGcaN3VjxEHibcFQdQGx1vZL9w4ZmRgCgbOTr_F2F17hlKEEApzMsKKhHZSPSs7bjfgdWHjt2Rv_0PZTYHYx", forHTTPHeaderField: "Authorization")

    
        switch self {
        case .getAllShops:
            return request
        case .getShop:
            return request
        }
    
    }

}
