//
//  ProductTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 28/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import ImageSlideshow
import Cosmos

class ProductTableViewController: UITableViewController {
    
    var product: Product!
    var inputs = [InputSource]()
    
    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
        imageSlide.setImageInputs(inputs)
        priceLabel.text = "\(product.price) S.R."
        nameLabel.text = product.name
        descriptionLabel.text = "Description:\n\n\(product.details ?? "")"
        ratingView.rating = Double(product.rate ?? "0.0") ?? 0.0
        ratingView.settings.fillMode = .precise
        imageSlide.slideshowInterval = 2.0
        imageSlide.contentScaleMode = .scaleAspectFill
        imageSlide.clipsToBounds = true
        imageSlide.zoomEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnImageSlide))
        imageSlide.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPhotos(){
        for photo in product.photos!{
            if let imgurl = URL(string: photo){
                inputs.append(KingfisherSource(url: imgurl))
            }
        }
        
    }

    
    
    @IBAction func didPressAddToCart(_ sender: Any) {
    }
    
   
    @objc func didTapOnImageSlide() {
        imageSlide.presentFullScreenController(from: self)
    }
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
