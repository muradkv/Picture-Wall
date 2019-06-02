//
//  Picture.swift
//  Picture Wall
//
//  Created by murad on 31/05/2019.
//  Copyright © 2019 murad. All rights reserved.
//

import Foundation

class Picture: Codable {
    
    var pictureName: String
    var image: String
    
    init(pictureName: String, image: String) {
        self.pictureName = pictureName
        self.image = image
    }
    
    required init(coder aDecoder: NSCoder) {
        pictureName = aDecoder.decodeObject(forKey: "pictureName") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(pictureName, forKey: "pictureName")
        aCoder.encode(image, forKey: "image")
    }
    
}
