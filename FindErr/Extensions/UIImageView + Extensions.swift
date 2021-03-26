//
//  UIImageView + Extensions.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import UIKit
import Foundation

//extenion to fetch the image and show in the imageview
extension UIImageView {
    func loadImage(url: String?) {
        guard let imageStringUrl = url, let imageUrl = URL(string: imageStringUrl) else { return }
        
        ApiService.shared().downloadShopImage(url: imageUrl) { (responseResult) in
            switch responseResult{
            case .success(let responseData):
                DispatchQueue.main.async {
                    if let imageData = responseData {
                        self.image = UIImage(data: imageData)
                    }
                }
            case .failure(error: let error):
                DispatchQueue.main.async {
                    self.image = UIImage(named: "shop")
                }
                print(error ?? "Image download error")
            }
           
        }

    }
}
