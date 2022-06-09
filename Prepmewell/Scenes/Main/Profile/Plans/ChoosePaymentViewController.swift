//
//  ChoosePaymentViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 01/06/2022.
//

import UIKit
import FlutterwaveSDK
import SwiftyUserDefaults
import NVActivityIndicatorView

class ChoosePaymentViewController: UIViewController, PlanDisplayLogic, NVActivityIndicatorViewable {
    func displayError(alert: String) {
        stopAnimating()
        handleErrorMessage(message: alert)
    }
    
    func displayPlans(plansResponse: ListResponse<Plan>) {}
    
    func displayUserPlans(plans: ListResponse<UserPlan>) {}
    
    func displayUserPlan(plan: DataResponse<UserPlan>) {
        stopAnimating()
        closeBack()
    }
    
    fileprivate func closeBack() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var flutterwaveView: UIView!
    
    var plan: Plan!
    var transRef: String!
    var interactor : PlanBusinessLogic?
    let size = CGSize(width: 80, height: 80)
    
    func setUpDependencies() {
        let interactor = PlanInteractor()
        let worker = PlanWorker()
        let presenter = PlanPresenter()
        let networkClient = PrepmewellApiClient()
       
        interactor.worker = worker
        interactor.presenter = presenter
       
        worker.networkClient = networkClient
       
        presenter.view = self
       
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(flutterwavePayClicked))
        flutterwaveView.addGestureRecognizer(tap)
        transRef = UUID().uuidString
        
        setUpDependencies()
    }
    
    func payFlutterwave(amount: Double, transRef: String, user: User){
        let config = FlutterwaveConfig.sharedConfig()
        config.paymentOptionsToExclude = []
        config.currencyCode = "NGN" // This is the specified currency to charge in.
        config.email = user.email
        config.isStaging = true
        config.transcationRef = transRef
        config.firstName = user.firstName
        config.lastName = user.lastName
        config.publicKey = "FLWPUBK_TEST-235febf0c5de309782ae856f138065c8-X" //Public key
        config.encryptionKey = "FLWSECK_TEST05f527bfc664" //Encryption key

        let controller = FlutterwavePayViewController()
        let nav = UINavigationController(rootViewController: controller)
        controller.amount = "\(amount)" // This is the amount to be charged.
        controller.delegate = self
        self.present(nav, animated: true)
    }
    
    @objc func flutterwavePayClicked(sender: UIButton!) {
        payFlutterwave(amount: plan.cost, transRef: transRef, user: Defaults[\.userData]!)
    }

}

extension ChoosePaymentViewController: FlutterwavePayProtocol {
    func onDismiss() {
        
    }
    

    func tranasctionSuccessful(flwRef: String?, responseData: FlutterwaveDataResponse?) {
        self.startAnimating(self.size, message: "Fetching plans...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        self.interactor!.updateUserPlan(data: UserPlanUpdate(planFK: plan!.recordNo, transactionID: transRef!, currency: "NG", productName: plan!.planName, name: plan!.planName, amount: plan!.cost, merchantID: "Prepmewell", orderNo: nil, subscriptionID: nil))
    }

    func tranasctionFailed(flwRef: String?, responseData: FlutterwaveDataResponse?) {
        print( "Failed transaction with FlwRef \(flwRef.orEmpty())")
        stopAnimating()
    }
}
