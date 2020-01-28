//
//  ViewController.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/27/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newsManager: NewsManager?
    var news: [NewsItem] = []
    var selectedIndexes: [Int] = []
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskAsatur")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    fileprivate func setupTableView() {
        
        tableView.register(UINib(nibName: String(describing: NewsItemCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NewsItemCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        selectedIndexes = UserDefaults.standard.array(forKey: "selectedIndexes") as? [Int] ?? []
        setupTableView()
        newsManager = NewsManager(persistentContainer: persistentContainer)
        newsManager?.loadData(complition: {[weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.activityIndicator.stopAnimating()
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let news):
                strongSelf.news = news
                strongSelf.tableView.reloadData()
            }
            
        })
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsItemCell.self), for: indexPath) as! NewsItemCell
        cell.render(item: news[indexPath.row], seen: selectedIndexes.contains(indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if !selectedIndexes.contains(indexPath.row) {
            selectedIndexes.append(indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        let detailController = storyBoard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as! DetailViewController
        detailController.newsIem = news[indexPath.row]
        splitViewController?.showDetailViewController(detailController, sender: nil)
    }
    
    
}
