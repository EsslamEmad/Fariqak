//
//  ProductsCollectionViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 28/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

private let reuseIdentifier = "Cell"
fileprivate let sectionInsets = UIEdgeInsets(top: 25.0, left: 15.0, bottom: 25.0, right: 15.0)

class ProductsCollectionViewController: UICollectionViewController {

    var products = [Product]()
    var category: Category!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getProductsIn(categoryID: category.code!))
            }.done {
                self.products = try! JSONDecoder().decode([Product].self, from: $0)
                self.collectionView?.reloadData()
            }.catch { error in
                self.showAlert(withMessage: NSLocalizedString("An error has occured, please try again later!", comment: ""))
            }.finally {
                SVProgressHUD.dismiss()
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
    
        // Configure the cell
        cell.layer.cornerRadius = 10.0
        cell.price.text = "\(products[indexPath.item].price) " + NSLocalizedString("S.R", comment: "")
        let imgs = products[indexPath.item].photos
            let img = imgs[0]
            if let imgurl = URL(string: img){
                cell.image.kf.indicatorType = .activity
                cell.image.kf.setImage(with: imgurl)
            
        }
        cell.name.text = products[indexPath.item].name
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowProductSegue", sender: products[indexPath.item])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductSegue"{
            let destination = segue.destination as! ProductTableViewController
            destination.product = sender as! Product
        }
    }

    @IBAction func unwindToVC(_ sender: UIStoryboardSegue) {
        
              
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension ProductsCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (2 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
