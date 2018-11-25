//
//  PublicImagesViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-11-23.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class PublicImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var search = ""
    fileprivate let reuseIdentifier = "PublicImageCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0);
    fileprivate var allImages = [Image]();
    fileprivate let itemsPerRow: CGFloat = 3 ;
    
    var images: [Image]?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! SearchableImageCollectionViewCell
        cell.image.image = images?[indexPath.item].fullImage
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = self.imageCollectionView.center
        self.activityIndicator.startAnimating() //For Start Activity Indicator
        self.view.addSubview(activityIndicator)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        self.fetchPublicImages()
        self.searchBar.enablesReturnKeyAutomatically = true
        self.searchBar.delegate = self
        if self.search != "" {
            self.searchBar.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            images = allImages
            self.imageCollectionView.reloadData()
        } else {
            images = allImages.filter { (image) -> Bool in
                image.ownerId?.lowercased().contains(searchText.lowercased()) ?? false || image.title?.lowercased().contains(searchText.lowercased()) ?? false
            }
            self.imageCollectionView.reloadData()
        }
    }
    
    private func getPublicImageURL() -> String {
        let username = UserDefaults.standard.string(forKey: "username")
        let apiURL = "http://localhost:3000/v2/imagesPublicExceptMine/"
        if (username == "anonymous") {
            let id = UserDefaults.standard.string(forKey: "id")!
            return "\(apiURL)\(id)"
        } else {
            let uuid = UUID().uuidString
            return "\(apiURL)\(uuid)"
        }
    }
    
    func fetchPublicImages() {
        guard let url = URL(string: getPublicImageURL()) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.allImages = [Image]()
                
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
                        self.allImages.append(image)
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.images = self.allImages
                    if self.search != "" {
                        self.images = self.allImages.filter { (image) -> Bool in
                            image.ownerId?.lowercased().contains(self.search.lowercased()) ?? false || image.title?.lowercased().contains(self.search.lowercased()) ?? false
                        }
                        self.searchBar.isHidden = true
                        self.imageCollectionView.reloadData()
                    }
                    self.imageCollectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPublicImage" {
            let PublicImageViewController = segue.destination as! PublicImageViewController
            if let cell = sender as? SearchableImageCollectionViewCell,
                let indexPath = self.imageCollectionView.indexPath(for: cell) {
                PublicImageViewController.image = images?[indexPath.item]
            }
        }
    }
}
