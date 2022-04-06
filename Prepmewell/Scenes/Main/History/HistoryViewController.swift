//
//  HistoryViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import UIKit
import NVActivityIndicatorView

protocol HistoryDisplayLogic {
    func displayHistory(history: ListResponse<TestResult>)
    func displayError(prompt: String)
}

class HistoryViewController: UIViewController, HistoryDisplayLogic, NVActivityIndicatorViewable {
    
    func displayHistory(history: ListResponse<TestResult>) {
        results = history.response
        results.sort{ $0.startTime! < $1.startTime! }
                            
        sectionResultsArrays.removeAll()
        sectionHeaderTitles.removeAll()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_GB")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        var currentDate: Date? = nil
        
        var section = -1
                            
        for data in results {
            if let date = dateFormatter.date(from: data.startTime!) {
                if (currentDate == nil || !isSameDay(date1: date, date2: currentDate!)) {
                    currentDate = date
                    
                    section += 1
                    
                    let tempList = [TestResult]()
                    
                    sectionHeaderTitles.append(relativeDateFormatter.string(from: currentDate!))
                    
                    sectionResultsArrays.append(tempList)
                    
                }
                sectionResultsArrays[section].append(data)
            }
        }
        table.reloadData()
    }
    
    func displayError(prompt: String) {
        
    }
    
    @IBOutlet weak var table: UITableView!
    
    var interactor : HistoryBusinessLogic?
    var preloader = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: .systemBackground, padding: .none)
    
    let size = CGSize(width: 80, height: 80)
    
    var results = [TestResult]()
    var sectionHeaderTitles = [String]()  //string array book types
        
    //var sectionBooks = [TestResult]()  // array of books of one type
    var sectionResultsArrays = [[TestResult]]()  //array of arrays
        
    let dateFormatter = DateFormatter()
    
    let cellReuseIdentifier = "historyCell"
    
    func setupDependencies() {
        let presenter = HistoryPresenter()
        presenter.homeView = self
        let networkClient = PrepmewellApiClient()
        let worker = HistoryWorker()
        worker.networkClient = networkClient
        let interactor = HistoryInteractor()
        interactor.worker = worker
        interactor.presenter = presenter
        self.interactor = interactor
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.isSkeletonable = true
        
        setupDependencies()
        interactor?.getHistory(page: 1)
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionResultsArrays[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
       // #imageLiteral(resourceName: "audio-fill")
        sectionHeaderLabelView.backgroundColor = UIColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.text = sectionHeaderTitles[section]
        sectionHeaderLabel.textColor = UIColor(named: "Text2")
        sectionHeaderLabel.font = UIFont(name:"Calibre-Medium", size:18)
        sectionHeaderLabel.frame = CGRect(x: 15, y: 0, width: 250, height: 20)
        sectionHeaderLabelView.addSubview(sectionHeaderLabel)

        return sectionHeaderLabelView

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCellView = self.table.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HistoryCellView
        
        cell.item = sectionResultsArrays[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
