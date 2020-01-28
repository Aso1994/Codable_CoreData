//
//  NewsManager.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/28/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//

import Foundation
import CoreData

typealias CompletionValue<T> = (_ response: Result<T, Error>) -> Void

class NewsManager {
    
    private var persistentContainer: NSPersistentContainer
    
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    
    func parse(_ jsonData: Data) -> Bool {
        do {
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve managed object context")
            }

            // Clear storage and save managed object instances
            clearStorage()

            // Parse JSON data
            let managedObjectContext = persistentContainer.viewContext
            let decoder = JSONDecoder()
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
            let jsonObject = try decoder.decode(JsonObject.self, from: jsonData)
            try managedObjectContext.save()

            return true
        } catch let error {
            print(error)
            return false
        }
    }

    func fetchFromStorage() -> [NewsItem]? {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NewsItem>(entityName: "NewsItem")
        let sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let users = try managedObjectContext.fetch(fetchRequest)
            return users
        } catch let error {
            print(error)
            return nil
        }
    }

    func clearStorage() {
        let isInMemoryStore = persistentContainer.persistentStoreDescriptions.reduce(false) {
            return $0 ? true : $1.type == NSInMemoryStoreType
        }

        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsItem")
        // NSBatchDeleteRequest is not supported for in-memory stores
        if isInMemoryStore {
            do {
                let users = try managedObjectContext.fetch(fetchRequest)
                for user in users {
                    managedObjectContext.delete(user as! NSManagedObject)
                }
            } catch let error as NSError {
                print(error)
            }
        } else {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(batchDeleteRequest)
            } catch let error as NSError {
                print(error)
            }
        }
    }

    
    func loadData(complition: @escaping CompletionValue<[NewsItem]>) {
        let urlString = "https://www.helix.am/temp/json.php"
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let storngSelf = self else {
                return
            }
            guard error == nil else { // loading from cache if error
                let news = storngSelf.fetchFromStorage()
                if news?.isEmpty ?? true {
                    DispatchQueue.main.async {
                        complition(.failure(error!))
                    }
                } else {
                    DispatchQueue.main.async {
                        complition(.success(news ?? []))
                    }
                }
               
                return
            }
            guard let jsonData = data else {
                DispatchQueue.main.async {
                    complition(.success([]))
                }
                return
            }
            if storngSelf.parse(jsonData) {
                let news = storngSelf.fetchFromStorage()
                DispatchQueue.main.async {
                    complition(.success(news ?? []))
                }
            } else {
                
            }
        }
        task.resume()
    }
    
}
