//
//  ProfileViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 10/02/2022.
//

import UIKit
import SwiftyUserDefaults

class ProfileViewController: UIViewController, HomeDisplayLogic {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var menuTable: UITableView!
    
    var menuItems = [
        ProfileMenuItem(name: "Profile settings", icon: #imageLiteral(resourceName: "Profile")),
        ProfileMenuItem(name: "My interests", icon: #imageLiteral(resourceName: "Hearts")),
        ProfileMenuItem(name: "Change password", icon: #imageLiteral(resourceName: "Password")),
        ProfileMenuItem(name: "Plans", icon: #imageLiteral(resourceName: "Plans")),
        ProfileMenuItem(name: "Contact us", icon: #imageLiteral(resourceName: "Contact"))
    ]
    let cellReuseIdentifier = "profileMenuCell"
    
    func displayUser(user: User?) {
        if let user = user {
            nameLabel.text = user.firstName != nil ? user.firstName! + " " + user.lastName! : user.fullName != nil ? user.fullName : ""
        }
        targetLabel.text = "TARGET SCORE: 8.0"
    }
    
    func displayDashboard(dashboard: Dashboard?) {
        
    }
    
    func displayError(prompt: String) {
        
    }
    
    func displayInterest(interests: ListResponse<Interest>) {
        
    }
    
    func logout() {}
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayUser(user: Defaults[\.userData])

        menuTable.delegate = self
        menuTable.dataSource = self
        menuTable.backgroundColor = .clear
    }
    
    func contactUsSelection(option: Int) {
        switch option {
        case 0:
            didPressCall(number: "+2348168320833")
            break;
        default:
            openWhatsApp(number: "+2348168320833")
            break;
        }
    }
    
    func openWhatsApp(number : String){
        var fullMob = number
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        let urlWhats = "whatsapp://send?phone=\(fullMob)"
            
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                        })
                } else {
                    handleErrorMessage(message: "WhatsApp Not Found on your device")
                        // Handle a problem
                }
            }
        }
    }
    
    func didPressCall(number: Any) {
        guard let url = URL(string: "tel://\(number)") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileMenuCellView = self.menuTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ProfileMenuCellView
                
        cell.item = self.menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            performSegue(withIdentifier: "openUpdatePassword", sender: nil)
            break
        case 4:
            let vc = MenuModalViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.menus = ["Call number", "Send message on whatsapp"]
            vc.selectMenu = self.contactUsSelection
            self.present(vc, animated: false)
            break;
        case 3:
            performSegue(withIdentifier: "openPlans", sender: nil)
            break
        default:
            performSegue(withIdentifier: "openProfileUpdate", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
