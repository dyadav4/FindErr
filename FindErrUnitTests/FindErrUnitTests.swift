//
//  FindErrUnitTests.swift
//  FindErrUnitTests
//
//  Created by Dharamvir Yadav on 6/15/20.
//

import XCTest
@testable import FindErr

class FindErrUnitTests: XCTestCase {
    
    func testGetStores() {
        
        let expectation = self.expectation(description: "stores")
        
        var stores: [Store]?
        
        ApiService.shared().fetchShopsWith(router: .getAllShops(searchterm: "Italian", latitude: 22, longitude: 22)) { (result) in
            switch result{
            case .success(let data):
                stores = data
            default:
                break
            }
            
            expectation.fulfill()
            
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNotNil(stores)
        
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
