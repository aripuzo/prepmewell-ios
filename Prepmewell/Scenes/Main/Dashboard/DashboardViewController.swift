//
//  DashboardViewController.swift
//  Prepmewell
//
//  Created by ari on 8/18/21.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var menuTable: UITableView!
    
    var dashboardMenuItems = [
        ProfileMenuItem(name: "General Writing Test", icon: #imageLiteral(resourceName: "edit-fill")),
        ProfileMenuItem(name: "Academic Writing Test", icon: #imageLiteral(resourceName: "edit-fill")),
        ProfileMenuItem(name: "Listening Test", icon: #imageLiteral(resourceName: "audio-fill")),
        ProfileMenuItem(name: "Academic Reading Test", icon: #imageLiteral(resourceName: "book-fill")),
        ProfileMenuItem(name: "General Reading Test", icon: #imageLiteral(resourceName: "book-fill")),
        ProfileMenuItem(name: "Speaking Test", icon: #imageLiteral(resourceName: "mic-fill"))
    ]
    let cellReuseIdentifier = "dashboardMenuCell"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTable.delegate = self
        menuTable.dataSource = self
        
        scheduleView.layer.masksToBounds = true
        
        navigationBar()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DashboardViewController.tapFunction))
        scheduleView.addGestureRecognizer(tap)
    }
    
    func navigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    @objc func tapFunction(sender:UITapGestureRecognizer) {
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DashboardMenuCellView = self.menuTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DashboardMenuCellView
                
        cell.item = self.dashboardMenuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var testTypeFk = 0
        var mockTypeFk = 0
        var title = ""
        
        switch indexPath.row {
        case 2:
            mockTypeFk = 0
            testTypeFk = Constants.TEST_TYPE_LISTENING
            title = "Listening Test"
        case 3, 4:
            mockTypeFk = indexPath.row == 3 ? 2 : 1
            testTypeFk = Constants.TEST_TYPE_READING
            title = "Reading Test"
        case 5:
            mockTypeFk = 0
            testTypeFk = Constants.TEST_TYPE_SPEAKING
            title = "Speaking Test"
        case 0, 1:
            mockTypeFk = indexPath.row == 1 ? 2 : 1
            testTypeFk = Constants.TEST_TYPE_WRITING
            title = "Writing Test"
        default:
            testTypeFk = 0
        }
        let newViewController = self.getStoryboard().instantiateViewController(withIdentifier: ScreenID.TEST_LIST) as! TestListViewController
        newViewController.testTypeFk = testTypeFk
        newViewController.mockTypeFk = mockTypeFk
        newViewController.testTitle = title
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
