//
//  ErrorType.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/11/20.
//

import Foundation

//to handle different errortypes.
//more can be handled such as for internet connection

public enum ErrorType {
    case parseUrlFail
    case notFound
    case validationError
    case serverError
    case defaultError
    
    var errorDescription: String? {
        switch self {
        case .parseUrlFail:
            return "Cannot initial URL object."
        case .notFound:
            return "Not Found"
        case .validationError:
            return "Validation Errors"
        case .serverError:
            return "Internal Server Error"
        case .defaultError:
            return "Something went wrong."
        }
    }
}
