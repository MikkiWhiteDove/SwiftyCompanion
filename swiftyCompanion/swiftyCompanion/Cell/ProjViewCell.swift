//
//  ProjViewCell.swift
//  swiftyCompanion
//
//  Created by Миша on 08.10.2021.
//

import UIKit

class ProjViewCell: UITableViewCell {

    @IBOutlet weak var nameProjLab: UILabel!
    @IBOutlet weak var infoProjLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
