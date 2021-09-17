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
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var wrappedView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static let identifier: String = "CardTableViewCell"
    
    static public func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: Bundle(for: CardTableViewCell.self))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    private func configureUI() {
        self.selectionStyle = .none
        self.eventImageView.layer.cornerRadius = 6.0
        self.detailsLabel.layer.masksToBounds = true
        self.detailsLabel.layer.cornerRadius = 12.0
    }
    
    public func setupCell(data: EventsViewModel) {
        let url: URL = URL(string: data.image ?? "")!
        let placeholder: UIImage = UIImage(named: "event4")!
        
        let processor = DownsamplingImageProcessor(size: self.eventImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        self.eventImageView.kf.indicatorType = .activity
        
        self.eventImageView.kf.setImage(with: url, placeholder: placeholder, options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
            ])
        self.eventTitleLabel.text = data.title
        if let date = data.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM - HH:mm 'h'"
            let dateEventFormatted  = dateFormatter.string(from: date)
            self.eventDateLabel.text = dateEventFormatted
        }
    }
    
}
