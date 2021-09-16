//
//  CardTableViewCell.swift
//  UI
//
//  Created by Samuel Brehm on 14/09/21.
//

import UIKit
import Presentation
import Kingfisher

class CardTableViewCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static let identifier: String = "CardTableViewCell"
    
    static public func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: Bundle(for: CardTableViewCell.self))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    public func setupCell(data: EventsViewModel) {
        if let imageUrl = data.image {
            self.eventImageView.kf.setImage(with: URL(string: imageUrl))
        }
        self.eventTitleLabel.text = data.title
        self.eventDescriptionLabel.text = data.description
    }
    
}
