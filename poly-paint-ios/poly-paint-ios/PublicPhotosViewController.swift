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
    fileprivate let itemsPerRow: CGFloat = 3 ;
    var images:[Image]?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    func getPublicImageUrl() -> String{
        if (UserDefaults.standard.string(forKey: "username") != "anonymous"){
            return "http://localhost:3000/v2/imagesPublicExceptMine/" + UserDefaults.standard.string(forKey: "id")!
        }
        else{
            return "http://localhost:3000/v2/imagesPublicExceptMine/" + UUID().uuidString
        }
    }
    
    func fetchPublicImages() {
        guard let url = URL(string: getPublicImageUrl()) else { return }
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
                    guard let url = image.getFullImageUrl(),
                        let imageData = try? Data(contentsOf: url as URL) else {
                            break
                    }
                    if let downloadedImage = UIImage(data: imageData){
                        image.fullImage = downloadedImage
                        self.images?.append(image)
                    }
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    override func viewDidLoad(){
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = self.collectionView!.center
        self.activityIndicator.startAnimating() //For Start Activity Indicator
        self.view.addSubview(activityIndicator)
        fetchPublicImages()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! PublicImageCell
        cell.imageView.image = images?[indexPath.item].fullImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPublicImage" {
            let PublicImageViewController = segue.destination as! PublicImageViewController
            if let cell = sender as? PublicImageCell,
                let indexPath = self.collectionView?.indexPath(for: cell) {
                PublicImageViewController.image = images?[indexPath.item]
            }
        }
    }
    
}
