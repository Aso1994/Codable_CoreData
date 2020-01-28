//
//  JsonObject.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/28/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//

import Foundation

class JsonObject: Decodable {
     
    var news: [NewsItem] = []
    
    public required convenience init(from decoder: Decoder) throws {
      self.init()
      let container = try decoder.container(keyedBy: CodingKeys.self)
        news = try container.decodeIfPresent([NewsItem].self, forKey: .metadata) ?? []
    }
    
    enum CodingKeys: String, CodingKey {
      case metadata
    }
    
}
