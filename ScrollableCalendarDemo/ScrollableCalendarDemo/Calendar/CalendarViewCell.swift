//
//  CalendarViewCell.swift
//  ScrollableCalendarDemo
//


import UIKit

@IBDesignable class CalendarViewCell: UICollectionViewCell {

    var date: Date?
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.numberLabel.text = "1"
    }
}
