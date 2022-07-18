//
//  CityPreviewCell.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 15/7/2022.
//

import UIKit


class CityPreviewCell: UITableViewCell {
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherDegreeLabel: UILabel!
    @IBOutlet weak var feelsLikeDegreeLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    
    var previewableObject: Previewable! {
        didSet {
            setupPreviewCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupPreviewCell() {
        weatherDescriptionLabel.text = previewableObject.weatherDescription
        weatherDegreeLabel.text = "\(previewableObject.weatherDegree)°"
        feelsLikeDegreeLabel.text = "Feels like it's \(previewableObject.feelsLikeDegree)°"
        weatherIconImageView.image = UIImage(named: previewableObject.weatherIconIcon)
        placeLabel.text = previewableObject.place
    }
}
