//
//  PostTableCell.swift
//  Test
//
//  Created by Piyush Sharma on 26/04/24.
//

import UIKit

class PostTableCell: UITableViewCell {

    
    static let identifier = "PostTableCell"
    
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(model: PostData) {
        self.idLabel.text = "\(model.id)."
        self.titleLabel.text = model.title.capitalized
    }
    
}
