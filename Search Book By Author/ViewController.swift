//
//  ViewController.swift
//  Search Book By Author
//
//  Created by fyz on 10/27/20.
//  Copyright © 2020 Feyza Topgul. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var authorField: UITextField!
    
    var author:String = ""
    private var bookUrl = ""
    private var imageUrl = ""
    var books = [Item] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        }

    @IBAction func searchBooksButton(_ sender: Any) {
        author = authorField.text ?? ""
        bookUrl = "https://www.googleapis.com/books/v1/volumes?q=inauthor:\(author)&key=API_KEY"
        getBooks()
    }
    func getBooks() {
        guard let encodedUrl = bookUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string:encodedUrl)
        guard let requestUrl = url else { fatalError() }
        
        let request = URLRequest(url: requestUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async{
                    print("Error took place \(error)")
                    return}
            }
            
            if let data = data {
                let decoder = JSONDecoder()
            
                do {
                    let searchedBooks = try decoder.decode(Book.self, from: data)
                DispatchQueue.main.async {
                    self.books = searchedBooks.items
                    self.performSegue(withIdentifier: "showBooks", sender: self)
                    }

                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBooks"{
            if let tableViewController = segue.destination as? TableViewController {
                tableViewController.searchedBooks = books
                tableViewController.imageUrl = imageUrl
            }
            
        }

        
    }
    
}

