//
//  Step4ViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 24/03/2022.
//

import UIKit
import BEMCheckBox
import NVActivityIndicatorView

protocol Step4DisplayLogic {
    func displayUpdateInterestResponse(response: StringResponse)
    func displayError(alert: String)
}

class Step4ViewController: UIViewController, Step4DisplayLogic, NVActivityIndicatorViewable {
    
    func displayUpdateInterestResponse(response: StringResponse) {
        self.stopAnimating()
        handleSuccessfulMessage(message: "Student interest updated successfully", successCompletion: { self.navigationController?.dismiss(animated: true, completion: nil) })
        
    }
    
    func displayError(alert: String) {
        self.stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    var interactor: QuestionnaireInteractor!
    var interestUpdate: InterestUpdate!
    var preloader = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: .systemBackground, padding: .none)
    let size = CGSize(width: 80, height: 80)
    
    @IBOutlet weak var IELTSCheckbox: BEMCheckBox!
    @IBOutlet weak var TOEFLCheckbox: BEMCheckBox!
    @IBOutlet weak var TOEICCheckbox: BEMCheckBox!
    
    @IBOutlet weak var UMATCheckbox: BEMCheckBox!
    @IBOutlet weak var GCECheckbox: BEMCheckBox!
    @IBOutlet weak var GEDGCheckbox: BEMCheckBox!
    @IBOutlet weak var ACTCheckbox: BEMCheckBox!
    @IBOutlet weak var GEDHCheckbox: BEMCheckBox!
    @IBOutlet weak var SATCheckbox: BEMCheckBox!
    @IBOutlet weak var UKCATCheckbox: BEMCheckBox!
    @IBOutlet weak var GMATCheckbox: BEMCheckBox!
    @IBOutlet weak var OATCheckbox: BEMCheckBox!
    
    @IBOutlet weak var nextButton: UIView!
    @IBOutlet weak var cancelButton: UIView!
    var englishCheckBoxes: [BEMCheckBox]?
    
    func setUpDependencies() {
        (interactor.presenter as! QuestionnairePresenter).step4View = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDependencies()
        
        IELTSCheckbox.boxType = .square
        TOEFLCheckbox.boxType = .square
        TOEICCheckbox.boxType = .square
        UMATCheckbox.boxType = .square
        GCECheckbox.boxType = .square
        GEDGCheckbox.boxType = .square
        ACTCheckbox.boxType = .square
        GEDHCheckbox.boxType = .square
        SATCheckbox.boxType = .square
        UKCATCheckbox.boxType = .square
        OATCheckbox.boxType = .square
        GMATCheckbox.boxType = .square
        
        let group = BEMCheckBoxGroup(checkBoxes: [IELTSCheckbox, TOEFLCheckbox, TOEICCheckbox])
        group.selectedCheckBox = IELTSCheckbox
        group.mustHaveSelection = true
        
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(Step2aViewController.didPressNextBtn))
        nextButton.addGestureRecognizer(nextTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(Step2aViewController.didPressCancelBtn))
        cancelButton.addGestureRecognizer(cancelTap)
    }
    
    @objc func didPressNextBtn(sender:UITapGestureRecognizer) {
        interestUpdate.isIELTS = IELTSCheckbox.on
        interestUpdate.isTOEFL = TOEFLCheckbox.on
        interestUpdate.isTOEIC = TOEICCheckbox.on
        
        interestUpdate.isUMAT = UMATCheckbox.on
        interestUpdate.isGCE = GCECheckbox.on
        interestUpdate.isGED = GEDGCheckbox.on
        interestUpdate.isACT = ACTCheckbox.on
        interestUpdate.isGED = GEDHCheckbox.on
        interestUpdate.isSAT = SATCheckbox.on
        interestUpdate.isUKCAT = UKCATCheckbox.on
        interestUpdate.isOAT = OATCheckbox.on
        interestUpdate.isGMAT = GMATCheckbox.on

        interactor?.updateInterest(data: interestUpdate)
        startAnimating(size, message: "Processing...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
    }
    
    @objc func didPressCancelBtn(sender:UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

}
