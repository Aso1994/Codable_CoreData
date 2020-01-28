//
//  NewsItemCell.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/28/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//

import UIKit
import Kingfisher

class NewsItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seenLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(item: NewsItem, seen: Bool) {
        titleLabel.text = item.title
        dateLabel.text = item.date
        seenLabel.isHidden = !seen
    }
    
}
