//
//  BoxListCell.swift
//  Projeto
//
//  Created by Eduarda Ramos on 09/12/2021.
//

import UIKit

class BoxListCell: UICollectionViewCell {
    @IBOutlet weak var boxName: UILabel!
    @IBOutlet weak var BoxCell: UIView!
    var identifier = "Custom cell"
    
    func setup(with box: Box)  {
        boxName.text = box.Nome
        identifier = box.Id
    }
}
