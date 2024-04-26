//
//  DetailViewController.swift
//  Test
//
//  Created by Piyush Sharma on 26/04/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var apiData: PostData?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let apiData {
            idLabel.text = "\(apiData.id)."
            titleLabel.text = apiData.title.capitalized
            bodyLabel.text = apiData.body.capitalized
        }
    }
    
    override class func description() -> String {
        return "DetailViewController"
    }

}
