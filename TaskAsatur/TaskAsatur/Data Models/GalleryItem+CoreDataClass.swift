//
//  GalleryItem+CoreDataClass.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/27/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GalleryItem)
public class GalleryItem: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailUrl
        case contnetUrl
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "GalleryItem", in: managedObjectContext) else {
            fatalError("Failed to decode Gallery")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.thumbnailUrl = try container.decodeIfPresent(URL.self, forKey: .thumbnailUrl)
        self.contentUrl = try container.decodeIfPresent(URL.self, forKey: .contnetUrl)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(thumbnailUrl, forKey: .thumbnailUrl)
        try container.encode(contentUrl, forKey: .contnetUrl)
    }
}


public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

