import UIKit

final class MyImagesViewController: UICollectionViewController {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "MyImageCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0);
    fileprivate var searches = [Image]();
    fileprivate let itemsPerRow: CGFloat = 3 ;
    var images:[Image]?
    
    func getPrivateImageUrl() -> String{
        
           // return "http://localhost:3000/v2/imagesByOwnerId/" + UserDefaults.standard.string(forKey: "id")!
         return "http://localhost:3000/v2/imagesByOwnerId/" + "694caab3-c611-4331-9e8a-7d0737d578a9"
    }
    func fetchPrivateImages() {
        guard let url = URL(string: getPrivateImageUrl()) else { return }
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
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    override func viewDidLoad(){
        fetchPrivateImages()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! PrivateImageCell
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name:"Main", bundle: nil)
        let PrivateImageVC = Storyboard.instantiateViewController(withIdentifier: "PrivateImageViewController") as!PrivateImageViewController
        PrivateImageVC.image = images?[indexPath.item]
        self.navigationController?.pushViewController(PrivateImageVC, animated: true)
    }
}

