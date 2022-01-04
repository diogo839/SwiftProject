//
//  DetailsTableViewCell.swift
//  Projeto
//
//  Created by Eduarda Ramos on 04/01/2022.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var symbol: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
