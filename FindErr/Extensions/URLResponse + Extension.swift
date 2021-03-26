//
//  URLResponse + Extension.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/12/20.
//

import Foundation

//to get the statuscode
extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
