//
//  TableViewController.swift
//  Search Book By Author
//
//  Created by fyz on 10/30/20.
//  Copyright © 2020 Feyza Topgul. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var searchedBooks = [Item]()
    var imageUrl = ""  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchedBooks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        if let title = searchedBooks[indexPath.row].volumeInfo.title {
            cell.titleLabel.text = "\(title)"
        }
        if let publisher = searchedBooks[indexPath.row].volumeInfo.publisher {
            cell.publisherLabel.text = "Publisher: \(publisher)"
        }
        if let author = searchedBooks[indexPath.row].volumeInfo.authors?[0] {
            cell.authorLabel.text = "Author: \(author)"
        }
        if let thumbnail = searchedBooks[indexPath.row].volumeInfo.imageLinks?.thumbnail{
            imageUrl = thumbnail
            cell.bookImage.load(urlString: imageUrl)
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let indexPaths = self.tableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            if let viewController = segue.destination as? BookViewController {
                let currentItem = searchedBooks[indexPath.row]
                viewController.bookTitle = currentItem.volumeInfo.title ?? ""
                viewController.author = currentItem.volumeInfo.authors?[0] ?? ""
                viewController.publisher = currentItem.volumeInfo.publisher ?? ""
                viewController.publishedDate = currentItem.volumeInfo.publishedDate ?? ""
                viewController.pageCount = currentItem.volumeInfo.pageCount ?? 0
                viewController.bookDescription = currentItem.volumeInfo.description ?? ""
                viewController.imageUrl = currentItem.volumeInfo.imageLinks?.thumbnail ?? ""
            }
        }
    }
    
}
extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
