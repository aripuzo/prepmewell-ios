//
//  PlansViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 01/06/2022.
//

import UIKit
import MSPeekCollectionViewDelegateImplementation
import NVActivityIndicatorView

protocol PlanDisplayLogic {
    func displayError(alert: String)
    func displayPlans(plansResponse: ListResponse<Plan>)
    func displayUserPlans(plans: ListResponse<UserPlan>)
    func displayUserPlan(plan: DataResponse<UserPlan>)
}

class PlansViewController: UIViewController, PlanDisplayLogic, NVActivityIndicatorViewable {
    func displayUserPlan(plan: DataResponse<UserPlan>) {}
    
    func displayError(alert: String) {
        stopAnimating()
        handleErrorMessage(message: alert)
    }
    
    func displayPlans(plansResponse: ListResponse<Plan>) {
        stopAnimating()
        plans.removeAll()
        plans.append(contentsOf: plansResponse.response)
        collectionView.reloadData()
        interactor?.getUserPlans()
    }
    
    func displayUserPlans(plans: ListResponse<UserPlan>) {
        plans.response.forEach{ plan in
            userPlan = plan
        }
        collectionView.reloadData()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var behavior: MSCollectionViewPeekingBehavior!
    let reuseIdentifier = "PlanCellView"
    var plans:[Plan] = []
    var interactor : PlanBusinessLogic?
    private let sectionInsets = UIEdgeInsets(
      top: 15.0,
      left: 15.0,
      bottom: 15.0,
      right: 15.0)
    let size = CGSize(width: 80, height: 80)
    var userPlan: UserPlan? = nil
    
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

        behavior = MSCollectionViewPeekingBehavior()
        collectionView.configureForPeekingBehavior(behavior: behavior)
        
        collectionView.register(UINib(nibName: "PlanCellView", bundle: nil),
                                  forCellWithReuseIdentifier: PlanCellView.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setUpDependencies()
        self.startAnimating(self.size, message: "Fetching plans...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        interactor?.getPlans()
    }

}

extension PlansViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.plans.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PlanCellView
        let plan = self.plans[indexPath.row]
        cell.setPlan(plan: plan, isActive: (plan.recordNo == self.userPlan?.planFK && self.userPlan?.isExpired() != true), isPayable: self.userPlan == nil)
        cell.choosePlan = {
            let newViewController = self.getStoryboard().instantiateViewController(withIdentifier: ScreenID.CHOOSE_PAYMENT) as! ChoosePaymentViewController
            newViewController.plan = plan
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
