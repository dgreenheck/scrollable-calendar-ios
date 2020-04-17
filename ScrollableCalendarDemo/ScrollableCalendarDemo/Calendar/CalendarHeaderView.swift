//
//  CalendarHeaderView.swift
//  ScrollableCalendarDemo
//

import UIKit

@IBDesignable class CalendarHeaderView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .systemBackground
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        self.titleLabel.textColor = .systemOrange
    }
}
