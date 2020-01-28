//
//  DetailViewController.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/28/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var newsIem: NewsItem?
    
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryLabel.text = newsIem?.category
        dateLabel.text = newsIem?.date
        titleLabel.text = newsIem?.title
        if let bodyText = newsIem?.body, let attrString = convertFromHtml(htmlString: bodyText) {
            bodyTextView.attributedText = attrString
        }
        // Do any additional setup after loading the view.
    }
    
    func convertFromHtml(htmlString: String) -> NSAttributedString? {
        guard let data = htmlString.data(using: .utf16) else {
            return nil
        }
        let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        return attributedString
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
