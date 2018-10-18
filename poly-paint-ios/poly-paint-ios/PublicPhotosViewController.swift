//
//  PublicPhotosViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 10/17/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit


final class PublicPhotosViewController: UICollectionViewController {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "PublicImageCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0);
    fileprivate var searches = [Image]();
    fileprivate let itemsPerRow: CGFLoat = 3 ;
    
    var images:[Image]?
    
    func fetchPublicImages() {
    guard let url = URL(string: "http://localhost:3000/images") else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
    
    if error != nil {
    print(error ?? "")
    return
    }
    
    do {
    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
    
    self.images = [Image]()
    
    for dictionary in json as! [[String: AnyObject]] {
    
    let image = Image()
        image.id = dictionary["id"] as? String
        image.ownerId = dictionary["ownerId"] as? String
        image.title = dictionary["title"] as? String
        image.protectionLevel = dictionary["protectionLevel"] as? String
        image.password = dictionary["password"] as? String
        image.thumbnailUrl = dictionary["thumbnailUrl"] as? String
        image.fullImageUrl = dictionary["fullImageUrl"] as? String
    
    self.images?.append(image)
    }
    
    DispatchQueue.main.async {
    self.collectionView?.reloadData()
    }
    
    
    } catch let jsonError {
    print(jsonError)
    }
    
    
    
    }.resume()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! ImageCell
        
        cell.image = image?[indexPath.item]
        
        return cell
    }

}
