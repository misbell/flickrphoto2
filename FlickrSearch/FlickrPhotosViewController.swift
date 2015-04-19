//
//  FlickrPhotosViewController.swift
//  FlickrSearch
//
//  Created by prenez on 4/15/15.
//  Copyright (c) 2015 Prenezsoft. All rights reserved.
//

import UIKit

class FlickrPhotosViewController : UICollectionViewController {
    
    private let reuseIdentifer = "FlickrCell"
    private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    
    private var searches = [FlickrSearchResults]()
    private let flickr = Flickr()
    
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
    var largePhotoIndexPath : NSIndexPath? {
        didSet {
            //2
            var indexPaths = [NSIndexPath]()
            if largePhotoIndexPath != nil {
                indexPaths.append(largePhotoIndexPath!)
            }
            if oldValue != nil {
                indexPaths.append(oldValue!)
            }
            //3
            collectionView?.performBatchUpdates({
                self.collectionView?.reloadItemsAtIndexPaths(indexPaths)
                return
                
                }) // and now the trailing closure
                {
                    completed
                    in
                    //4
                    if self.largePhotoIndexPath != nil {
                        self.collectionView?.scrollToItemAtIndexPath(self.largePhotoIndexPath!, atScrollPosition: .CenteredVertically, animated: true)
                    }
            
            }
        }
    }
}

extension FlickrPhotosViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        flickr.searchFlickrForTerm(textField.text) {
            results, error in
            
            //2
            activityIndicator.removeFromSuperview()
            if error != nil {
                println("Error searching : \(error)")
            }
            
            if results != nil {
                // 3
                println("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex:0)
                
                // 4
                self.collectionView?.reloadData()
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()  // important on text field...that has focus
        
        
        return true
    }
}

extension FlickrPhotosViewController : UICollectionViewDataSource {
    
    // 1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    // 2 return the number of items here (like rows in tableview)
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    // 3 return the cell here
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        
        //1
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifer, forIndexPath: indexPath) as! FlickrPhotoCell
        
        //2
        let flickrPhoto = photoForIndexPath(indexPath)
        

        //1
        cell.activityIndicator.stopAnimating()
        
        //2
        if indexPath != largePhotoIndexPath {
            cell.imageView.image = flickrPhoto.thumbnail
            return cell
        }
        
        //3
        if flickrPhoto.largeImage != nil {
            cell.imageView.image = flickrPhoto.largeImage
            return cell
        }
        
        //4
        cell.imageView.image = flickrPhoto.thumbnail
        cell.activityIndicator.startAnimating()
        
        //5
        flickrPhoto.loadLargeImage {
            loadedFlickrPhoto, error
            in
            //6
            cell.activityIndicator.stopAnimating()
            
            //7
            if error != nil {
                return
            }
            
            if loadedFlickrPhoto.largeImage == nil {
            return
            }
            
            // 8
            if indexPath == self.largePhotoIndexPath {
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? FlickrPhotoCell {
                    cell.imageView.image = loadedFlickrPhoto.largeImage
                }
            
            }
        }
        
        
        return cell
        
        
        
    }
    
    // this method is for supplementary views, such as the header view
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            
            switch kind {
                //2 
            case UICollectionElementKindSectionHeader:
                //3
                let headerView =
               collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "FlickrPhotoHeaderView", forIndexPath: indexPath) as! FlickrPhotoHeaderView
                    
                headerView.label.text = searches[indexPath.section].searchTerm
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
            
            return UICollectionReusableView()
    }
    
}

extension FlickrPhotosViewController : UICollectionViewDelegateFlowLayout {
    
    // 1
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let flickrPhoto = photoForIndexPath(indexPath)
            
            // new code make the cell bigger for bigger photo on selection
            if indexPath == largePhotoIndexPath {
                var size = collectionView.bounds.size
                size.height -= topLayoutGuide.length
                size.height -= (sectionInsets.top + sectionInsets.right)
                size.width  -= (sectionInsets.left + sectionInsets.right)
                return flickrPhoto.sizeToFillWidthOfSize(size)
            }
            
            //2
            if var size = flickrPhoto.thumbnail?.size {
                size.width += 10
                size.height += 10
                return size
            }
            
            return CGSize(width: 100, height: 100)
    }
    
    // 3
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

extension FlickrPhotosViewController : UICollectionViewDelegate {
    
    // select the item
    override func collectionView(collectionView: UICollectionView,
        shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
            if largePhotoIndexPath == indexPath {
                largePhotoIndexPath = nil
            }
            else {
                largePhotoIndexPath = indexPath
            }
            return false
    }
}






