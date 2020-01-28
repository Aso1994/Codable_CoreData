//
//  NewsItem+CoreDataProperties.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/27/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsItem> {
        return NSFetchRequest<NewsItem>(entityName: "NewsItem")
    }

    @NSManaged public var category: String?
    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var coverPhotoUrl: URL?
    @NSManaged public var sharePhotoUrl: URL?
    @NSManaged public var gallery: NSSet?

}

// MARK: Generated accessors for gallery
extension NewsItem {

    @objc(addGalleryObject:)
    @NSManaged public func addToGallery(_ value: GalleryItem)

    @objc(removeGalleryObject:)
    @NSManaged public func removeFromGallery(_ value: GalleryItem)

    @objc(addGallery:)
    @NSManaged public func addToGallery(_ values: NSSet)

    @objc(removeGallery:)
    @NSManaged public func removeFromGallery(_ values: NSSet)

}
