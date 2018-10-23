//
//  Image.swift
//  poly-paint-ios
//
//  Created by JP Cech on 10/17/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class Image: NSObject {
    
    var id: String?
    var ownerId: String?
    var title: String?
    var protectionLevel: String?
    var password: String?
    var thumbnailUrl: String?
    var fullImageUrl: String?
    var thumbnail: UIImage?
    var fullImage: UIImage?
    
    func getThumbnailUrl()  -> URL? {
        if let url = URL(string :thumbnailUrl!){
            return url
        }
        return nil
    }
    
    func getFullImageUrl()  -> URL? {
        if let url = URL(string :fullImageUrl!){
            return url
        }
        return nil
    }
    
}
