//
//  WeatherCell.swift
//  DemoRxTableView
//
//  Created by MAC on 8/25/22.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
