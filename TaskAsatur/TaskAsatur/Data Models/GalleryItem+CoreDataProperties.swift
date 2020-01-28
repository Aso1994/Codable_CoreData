//
//  GalleryItem+CoreDataProperties.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/27/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//
//

import Foundation
import CoreData


extension GalleryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GalleryItem> {
        return NSFetchRequest<GalleryItem>(entityName: "GalleryItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var thumbnailUrl: URL?
    @NSManaged public var contentUrl: URL?

}
