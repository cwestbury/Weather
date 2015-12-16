//
//  WeatherCustomTableViewCell.swift
//  swiftWeather
//
//  Created by Cameron Westbury on 11/3/15.
//  Copyright © 2015 Cameron Westbury. All rights reserved.
//

import UIKit

class WeatherCustomTableViewCell: UITableViewCell {
    @IBOutlet var weatherImage : UIImageView!
    @IBOutlet var summaryLabel : UILabel!
    @IBOutlet var percipProbabilityLabel : UILabel!
    @IBOutlet var temperatureLabel : UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var windSpeedLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
