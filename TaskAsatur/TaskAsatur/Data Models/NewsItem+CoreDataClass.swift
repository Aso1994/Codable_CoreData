//
//  NewsItem+CoreDataClass.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/27/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NewsItem)
public class NewsItem: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case category
        case title
        case body
        case date
        case gallery
        case sharePhotoUrl
        case coverPhotoUrl
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "NewsItem", in: managedObjectContext) else {
            fatalError("Failed to decode News")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.coverPhotoUrl = try container.decodeIfPresent(URL.self, forKey: .coverPhotoUrl)
        self.sharePhotoUrl = try container.decodeIfPresent(URL.self, forKey: .sharePhotoUrl)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        let dateIntValue = try container.decodeIfPresent(Int.self, forKey: .date)
        self.date = getReadableDate(timeStamp: Double(dateIntValue ?? 0))
        let galleryArray = try container.decodeIfPresent([GalleryItem].self, forKey: .gallery)
        self.gallery = NSSet(array: galleryArray ?? [])
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(coverPhotoUrl, forKey: .coverPhotoUrl)
        try container.encode(sharePhotoUrl, forKey: .sharePhotoUrl)
        try container.encode(body, forKey: .body)
        try container.encode(category, forKey: .category)
        try container.encode(date, forKey: .date)
        try container.encode(gallery?.allObjects as? [GalleryItem], forKey: .gallery)
    }
    
    func getReadableDate(timeStamp: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }

    func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
}


