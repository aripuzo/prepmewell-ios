//
//  NewScheduleViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 07/04/2022.
//

import UIKit
import BEMCheckBox
import NVActivityIndicatorView
import SwiftyUserDefaults

protocol NewScheduleDisplayLogic {
    func displayScheduleTestResponse(response: DataResponse<Schedule>)
    func displayError(alert: String)
    func displayTestTypes(response: ListResponse<TestType>)
    func displayMockTests(response: ListResponse<MockTest>)
}

class NewScheduleViewController: UIViewController, NewScheduleDisplayLogic, NVActivityIndicatorViewable {
    
    func displayScheduleTestResponse(response: DataResponse<Schedule>) {
        self.stopAnimating()
        handleSuccessfulMessage(message: "Test scheduled successfully created", successCompletion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func displayTestTypes(response: ListResponse<TestType>) {
        testTypes.removeAll()
        testTypes.append(contentsOf: response.response)
        testFormatTextField.loadDropdownData(data: testTypes, onSelect: testType_onSelect)
        
        if !testTypes.isEmpty {
            scheduleUpdate.testTypeFK = testTypes[0].recordNo
            interactor?.getMockTests(testTypeFk: testTypes[0].recordNo, mockTypeFK: nil, pageNo: nil)
        }
    }
    
    func displayMockTests(response: ListResponse<MockTest>) {
        mockTests.removeAll()
        mockTests.append(contentsOf: response.response)
        testVolumeTextField.loadDropdownData(data: mockTests, onSelect: mockTest_onSelect)
        
        if !mockTests.isEmpty {
            scheduleUpdate.mockTestFK = mockTests[0].recordNo
            scheduleUpdate.mockTypeFK = mockTests[0].mockTypeFK
        }
    }
    
    func displayError(alert: String) {
        self.stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    @IBOutlet weak var testFormatTextField: UITextField!
    @IBOutlet weak var testVolumeTextField: UITextField!
    @IBOutlet weak var testDayTextField: UITextField!
    @IBOutlet weak var testTimeTextField: UITextField!
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var smsCheckbox: BEMCheckBox!
    @IBOutlet weak var emailCheckbox: BEMCheckBox!
    
    var preloader = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: .systemBackground, padding: .none)
    let size = CGSize(width: 80, height: 80)
    var testTypes:[TestType] = []
    var mockTests:[MockTest] = []
    var interactor : TestScheduleBusinessLogic?
    var scheduleUpdate = ScheduleUpdate()
    var userData: User!
    
    func setUpDependencies() {
        let interactor = TestScheduleInteractor()
        let worker = TestScheduleWorker()
        let presenter = TestSchedulePresenter()
        let networkClient = PrepmewellApiClient()
       
        interactor.worker = worker
        interactor.presenter = presenter
       
        worker.networkClient = networkClient
       
        presenter.view2 = self
       
        self.interactor = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        smsCheckbox.boxType = .square
        emailCheckbox.boxType = .square
        
        let group = BEMCheckBoxGroup(checkBoxes: [smsCheckbox, emailCheckbox])
        group.selectedCheckBox = smsCheckbox
        group.mustHaveSelection = true
        
        self.testDayTextField.datePicker(target: self, doneAction: #selector(doneAction), cancelAction: #selector(cancelAction), datePickerMode: .date)
        
        self.testTimeTextField.datePicker(target: self, doneAction: #selector(doneActionTime), cancelAction: #selector(cancelAction), datePickerMode: .time)
        
        userData = Defaults[\.userData]
        
        smsLabel.text = "SMS (\(userData!.phoneNumber!))"
        emailLabel.text = "Email (\(userData!.email))"
        
        setUpDependencies()
        interactor?.getTestTypes()
    }
    
    func mockTest_onSelect(selectedText: String, selectedPosition: Int) {
        scheduleUpdate.mockTestFK = mockTests[selectedPosition].recordNo
        scheduleUpdate.mockTypeFK = mockTests[selectedPosition].mockTypeFK
    }
    
    func testType_onSelect(selectedText: String, selectedPosition: Int) {
        scheduleUpdate.testTypeFK = testTypes[selectedPosition].recordNo
        interactor?.getMockTests(testTypeFk: testTypes[selectedPosition].recordNo, mockTypeFK: nil, pageNo: nil)
    }
    
    @IBAction func didPressUpdateBtn() {
        scheduleUpdate.phoneNumber = smsCheckbox.on ? userData!.phoneNumber! : nil
        scheduleUpdate.email = emailCheckbox.on ? userData!.email : nil
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        scheduleUpdate.dateTime = dateformat.string(from: Date())
        
        scheduleUpdate.scheduleTime = "\(testDayTextField.text!)T\(testTimeTextField.text!)"
        
        if (scheduleUpdate.mockTestFK != nil && scheduleUpdate.testTypeFK != nil && scheduleUpdate.dateTime != nil && scheduleUpdate.scheduleTime != nil){
            interactor?.scheduleTest(data: scheduleUpdate)
            startAnimating(size, message: "Processing...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        } else {
            let alertController = UIAlertController(title: "Empty Input Fields", message: "Please enter all options", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func cancelAction() {
        self.testDayTextField.resignFirstResponder()
        self.testTimeTextField.resignFirstResponder()
    }

    @objc func doneAction() {
        if let datePickerView = self.testDayTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.testDayTextField.text = dateString
                
            print(datePickerView.date)
            print(dateString)
                
            self.testDayTextField.resignFirstResponder()
        }
    }
    
    @objc func doneActionTime() {
        if let datePickerView = self.testTimeTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ssZ"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.testTimeTextField.text = dateString
                
            self.testTimeTextField.resignFirstResponder()
        }
    }

}
