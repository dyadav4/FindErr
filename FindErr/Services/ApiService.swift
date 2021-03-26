//
//  ApiService.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import Foundation
import UIKit
import Network


//this class will be used to fetch all the necessary data
public class ApiService: NSObject {
    
    private override init() {}
    public static let _shared = ApiService()
    
    class func shared() -> ApiService {
        return _shared
    }
    
    let urlSessionShared = URLSession.shared
    
}


extension ApiService: ApiServiceProtocol{
    
    //fetchin all the shops based on the apirouter
    func fetchShopsWith(router: APIRouter, completion: @escaping (Result<[Store]>) -> Void) {
        do {
            let dataTask = try urlSessionShared.dataTask(with: router.request()!) { (data, response, error) in
                
                if let error = error {
                    completion(.failure(error: error))
                    return
                }
                
                guard let statusCode = response?.getStatusCode(), (200...209).contains(statusCode) else {
                    
                    let errorType: ErrorType
                    
                    switch response?.getStatusCode(){
                    case 404:
                        errorType = .notFound
                    case 422:
                        errorType = .validationError
                    case 500:
                        errorType = .serverError
                    default:
                        errorType = .defaultError
                    }
                    
                    completion(.failure(error: errorType as? Error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(error: ErrorType.defaultError as? Error))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResults.self, from: data)
                    completion(.success(result.businesses))
                } catch let error {
                    completion(.failure(error: error))
                }
            }
            dataTask.resume()
        }catch let error {
            completion(.failure(error: error))
        }
        
    }
    
    
    //downloading the images based on the URL
    func downloadShopImage(url: URL, completion: @escaping (Result<Data?>) -> Void) {
        
        urlSessionShared.dataTask(with: url) { (data, response, error) in
            
            if let error = error{
                completion(.failure(error: error.localizedDescription as? Error))
                return
            }
            
            guard response != nil else {
                completion(.failure(error: "No reponse from the Image url" as? Error))
                return
            }
            
            guard let data = data else {
                completion(.failure(error: "No data from the Image url" as? Error))
                return
            }
            
            guard let image = UIImage(data: data), let compressedImage = image.jpegData(compressionQuality: 0.25) else {
                return
            }
            
            completion(.success(compressedImage))
        }.resume()
    
    }
    
}
