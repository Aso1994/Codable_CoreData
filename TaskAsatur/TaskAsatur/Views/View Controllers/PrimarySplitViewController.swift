//
//  PrimarySplitViewController.swift
//  TaskAsatur
//
//  Created by Asatur Harutyunyan on 1/28/20.
//  Copyright © 2020 Asatur Harutyunyan. All rights reserved.
//

import UIKit

class PrimarySplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .allVisible
        // Do any additional setup after loading the view.
    }
    
}

extension PrimarySplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
             _ splitViewController: UISplitViewController,
             collapseSecondary secondaryViewController: UIViewController,
             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
