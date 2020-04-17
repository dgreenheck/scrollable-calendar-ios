//
//  CalendarViewController.swift
//  ScrollableCalendarDemo
//

import UIKit
import CoreData

/// View controller which displays a scrollable calendar
class ScrollableCalendarViewController: UIViewController {

    // MARK: - Constants
    
    // MARK: - Members
    
    /// Reference to the Gregorian calendar
    let calendar = Calendar.init(identifier: .gregorian)
    
    var selectedDate: Date?
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register the header view
        collectionView.register(UINib(nibName: "CalendarHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "calenderHeaderView")
        // Register the cell view
        collectionView.register(UINib(nibName: "CalendarViewCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        let dayOffset = getDayOffset(year: year, month: month)
        
        collectionView.scrollToItem(at: IndexPath(item: day + dayOffset + 7, section: 60), at: .centeredVertically, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let vc = segue.destination as? DayViewController {
            vc.date = self.selectedDate
        }
    }
}

extension ScrollableCalendarViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12*10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "calendarHeaderView", for: indexPath) as? CalendarHeaderView {
            let year = getYearForIndexPath(indexPath: indexPath)
            let month = getMonthForIndexPath(indexPath: indexPath)
            let dateComponents = DateComponents(year: year, month: month)
            let date = calendar.date(from: dateComponents)
            sectionHeader.titleLabel.text = date?.toString(dateFormat: "MMMM YYYY")
            return sectionHeader
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        let indexPath = IndexPath(item: 0, section: section)
        
        let year = getYearForIndexPath(indexPath: indexPath)
        let month = getMonthForIndexPath(indexPath: indexPath)
        
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!

        return range.count + getDayOffset(year: year, month: month)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarViewCell

        // Display the weekday ordinal in the calendar cell
        let year = getYearForIndexPath(indexPath: indexPath)
        let month = getMonthForIndexPath(indexPath: indexPath)
        if let day = getDayForIndexPath(indexPath: indexPath) {
            let date = calendar.date(from: DateComponents(calendar: calendar, year: year, month: month, day: day))!
            cell.date = date
            cell.numberLabel?.text = "\(day)"
            
            // If the day matches today, highlight the number with a different color
            if calendar.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
                cell.numberLabel?.textColor = .systemOrange
            } else {
                cell.numberLabel?.textColor = .label
            }
        } else {
            cell.date = nil
            cell.numberLabel?.text = ""
            cell.numberLabel?.textColor = .label
        }
        
        
        return cell
    }
    
    /// Returns the year that should be displayed at the specified index path
    private func getYearForIndexPath(indexPath: IndexPath) -> Int {
        let shiftedDate = calendar.date(byAdding: .month, value: indexPath.section - 60, to: Date())!
        let year = calendar.component(.year, from: shiftedDate)
        return year
    }
    
    /// Returns month that should be displayed at the specified index path
    private func getMonthForIndexPath(indexPath: IndexPath) -> Int {
        let shiftedDate = calendar.date(byAdding: .month, value: indexPath.section - 60, to: Date())!
        let month = calendar.component(.month, from: shiftedDate)
        return month
    }
    
    /// Returns the day of month that should be displayed at the specified index path
    private func getDayForIndexPath(indexPath: IndexPath) -> Int? {
        let year = getYearForIndexPath(indexPath: indexPath)
        let month = getMonthForIndexPath(indexPath: indexPath)
        let day = indexPath.row - getDayOffset(year: year, month: month) + 1
        
        guard day >= 1 else {
            return nil
        }
        
        return day
    }
    
    /// Returns the day offset for the specified year and month. The day
    /// offset is used to shift the days in the calendar view so the weekday
    /// ordinal is aligned with the correct weekday.
    private func getDayOffset(year: Int, month: Int) -> Int {
        // Get the weekday ordinal for the first day of the month
        let startOfMonth = calendar.date(from: DateComponents(calendar: calendar,
                                                              year: year, month: month,
                                                              day:  1))!
        let dayOffset = calendar.component(.weekday, from: startOfMonth) - 1
        return dayOffset
    }
}

extension ScrollableCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.minimumInteritemSpacing * CGFloat(6)
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(7))
        return CGSize(width: size, height: 64)
    }
}

extension ScrollableCalendarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CalendarViewCell else {
            return
        }
        
        // If cell has no date, it's just a filler cell
        if let date = selectedCell.date {
            self.selectedDate = date
            self.performSegue(withIdentifier: "daySegue", sender: self)
        }
    }
}
