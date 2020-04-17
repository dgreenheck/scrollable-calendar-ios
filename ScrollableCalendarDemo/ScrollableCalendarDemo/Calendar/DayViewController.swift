//
//  DayViewController.swift
//  ScrollableCalendarDemo
//

import UIKit

class DayViewController: UIViewController {

    var date: Date!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = self.date.toString(dateFormat: "MMMM dd, YYYY")
    }
}
