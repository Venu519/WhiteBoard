//
//  Subject.swift
//  WhiteBoard
//
//  Created by Venugopal Reddy Devarapally on 06/04/17.
//  Copyright © 2017 venu. All rights reserved.
//

import UIKit
import os.log

class Subject: NSObject, NSCoding {
    
    var title: String
    var subTitle: String
    var photo: UIImage!
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("subjects")
    
    struct PropertyKey {
        static let title = "title"
        static let photo = "photo"
        static let subTitle = "subTitle"
    }
    
    init?(title: String, subTitle: String, photo: UIImage?) {
        
        // The name must not be empty
        guard !title.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard !subTitle.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.title = title
        if (photo != nil) {
            self.photo = photo!
        }
        self.subTitle = subTitle
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(subTitle, forKey: PropertyKey.subTitle)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for a Subject object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let subTitle = aDecoder.decodeObject(forKey: PropertyKey.subTitle) as? String else {
            os_log("Unable to decode the name for a Subjetc object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        self.init(title: title, subTitle: subTitle, photo: photo!)
    }
}
