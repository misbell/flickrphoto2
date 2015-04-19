//
//  FlickrPhotoCell.swift
//  FlickrSearch
//
//  Created by prenez on 4/18/15.
//  Copyright (c) 2015 Prenezsoft. All rights reserved.
//

import UIKit

class FlickrPhotoCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selected = false
    }
    
    // aha overriding properties
    override var selected : Bool {
        didSet {
            self.backgroundColor
                = selected ? themeColor : UIColor.blackColor()
        }
    }
    
    
}

