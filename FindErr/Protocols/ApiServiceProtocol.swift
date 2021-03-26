//
//  ApiServiceProtocol.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import Foundation
import MapKit

// look for the succces and failure
enum Result<T>{
    case success(T)
    case failure(error: Error?)
}

//protocol to fetch the data
protocol ApiServiceProtocol {
    func fetchShopsWith(router: APIRouter, completion: @escaping (Result<[Store]>) -> Void)

    func downloadShopImage(url: URL, completion: @escaping (Result<Data?>) -> Void)
}


