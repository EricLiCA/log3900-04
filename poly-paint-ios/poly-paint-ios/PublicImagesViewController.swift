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
    @IBOutlet weak var searchType: UISegmentedControl!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var search = ""
    fileprivate let reuseIdentifier = "PublicImageCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0);
    fileprivate var allImages = [Image]();
    fileprivate let itemsPerRow: CGFloat = 3 ;
    
    var images: [Image]?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var likesUpdated = 0
    var searching = false
    var searchByUser = true
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! SearchableImageCollectionViewCell
        cell.image.image = images?[indexPath.item].fullImage
        cell.likesLabel.text = "Likes: \(images![indexPath.item].likes.count)"
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
    
    @IBAction func searchFilterTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            searchByUser = true
        case 1:
            searchByUser = false
        default:
            searchByUser = true
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            images = allImages
            self.imageCollectionView.reloadData()
        } else {
            images = allImages.filter { (image) -> Bool in
                
                searchByUser && image.ownerId?.lowercased().contains(searchText.lowercased()) ?? false || !searchByUser && image.title?.lowercased().contains(searchText.lowercased()) ?? false
            }
            self.imageCollectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
    }
    
    private func getPublicImageURL() -> String {
        let username = UserDefaults.standard.string(forKey: "username")
        let apiURL = SERVER.URL.rawValue + "v2/imagesPublicExceptMine/"
        if (username != "anonymous") {
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
                            continue
                    }
                    if let downloadedImage = UIImage(data: imageData){
                        image.fullImage = downloadedImage
                        self.allImages.append(image)
                    }
                }
                
                DispatchQueue.main.async {
                    self.updateLikes()
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    private func getLikeURL(image: Image) -> String {
        return "\(SERVER.URL.rawValue)v2/imageLikes/\(image.id!)"
    }
    
    func updateLikes() {
        self.likesUpdated = 0
        guard allImages.count > 0 else {
            self.initializeImages()
            return
        }
        for i in 0...allImages.count - 1 {
            guard let url = URL(string: getLikeURL(image: allImages[i])) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    print(json)
                    for dictionary in json as! [[String: AnyObject]] {
                        self.allImages[i].likes.insert(dictionary["userId"] as! String)
                    }
                    
                    DispatchQueue.main.async {
                        self.likesUpdated += 1
                    }
                } catch let jsonError {
                    DispatchQueue.main.async {
                        self.likesUpdated += 1
                    }
                    print(jsonError)
                }
            }.resume()
        }
        self.initializeImages()
    }
    
    func initializeImages() {
        if self.likesUpdated < self.allImages.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.initializeImages()
            }
        } else {
            self.images = self.allImages
            if self.search != "" {
                self.images = self.allImages.filter { (image) -> Bool in
                    image.ownerId?.lowercased().contains(self.search.lowercased()) ?? false
                }
                self.searchBar.isHidden = true
                if (!searching) {
                    self.imageCollectionView.reloadData()
                }
            }
            if (!searching) {
                self.imageCollectionView.reloadData()
            }
            self.activityIndicator.stopAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.updateLikes()
            }
        }
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
