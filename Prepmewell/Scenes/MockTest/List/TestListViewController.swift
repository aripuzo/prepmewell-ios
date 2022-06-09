//
//  TestListViewController.swift
//  Prepmewell
//
//  Created by ari on 8/18/21.
//

import UIKit
import SkeletonView
import NVActivityIndicatorView

protocol TestListDisplayLogic {
    func displayMockTests(mockTestResponse: ListResponse<MockTest>)
    func startTestResponse(response: StringResponse)
    func displayError(alert: String)
}

class TestListViewController: UIViewController, TestListDisplayLogic, NVActivityIndicatorViewable {
    
    func displayMockTests(mockTestResponse: ListResponse<MockTest>){
        hideSkeleton()
        mockTests.removeAll()
        mockTests.append(contentsOf: mockTestResponse.response)
        testList.reloadData()
    }

    func startTestResponse(response: StringResponse) {
        stopAnimating()
        var newViewController: TestViewController
        switch mockTest?.testTypeFk {
        case Constants.TEST_TYPE_WRITING:
            newViewController = self.getStoryboard().instantiateViewController(withIdentifier: ScreenID.WRITING_TEST) as! WritingTestViewController
            (newViewController as! WritingTestViewController).writingTypeName = self.writingTypeName
        case Constants.TEST_TYPE_READING:
            newViewController = self.getStoryboard().instantiateViewController(withIdentifier: ScreenID.READING_TEST) as! ReadingTestViewController
        case Constants.TEST_TYPE_LISTENING:
            newViewController = self.getStoryboard().instantiateViewController(withIdentifier: ScreenID.LISTENING_TEST) as! ListeningTestViewController
        case Constants.TEST_TYPE_SPEAKING:
            newViewController = self.getStoryboard().instantiateViewController(withIdentifier: ScreenID.SPEAKING_TEST) as! SpeakingTestViewController
        default:
            newViewController = self.getStoryboard().instantiateViewController(withIdentifier: ScreenID.TEST_LIST) as! ReadingTestViewController
        }
        newViewController.mockTest = self.mockTest
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func displayError(alert: String) {
        stopAnimating()
        hideSkeleton()
        handleErrorMessage(message: alert)
    }
    
    @IBOutlet weak var testList: UICollectionView!
    
    var interactor : TestListBusinessLogic?
    let reuseIdentifier = "mockTestCell"
    private let sectionInsets = UIEdgeInsets(
      top: 15.0,
      left: 15.0,
      bottom: 15.0,
      right: 15.0)
    let size = CGSize(width: 80, height: 80)
    private let itemsPerRow: CGFloat = 2

    
    var mockTests: [MockTest] = []
    var testTypeFk: Int!
    var mockTypeFk: Int!
    var testTitle: String!
    var mockTest: MockTest? = nil
    var writingTypeName: String? = nil
    
    func setUpDependencies() {
        let interactor = TestListInteractor()
        let worker = TestListWorker()
        let presenter = TestListPresenter()
        let networkClient = PrepmewellApiClient()
       
        interactor.worker = worker
        interactor.presenter = presenter
       
        worker.networkClient = networkClient
       
        presenter.view = self
       
        self.interactor = interactor
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testList.delegate = self
        testList.dataSource = self
        testList.isSkeletonable = true
        
        self.title = testTitle!
        
//        testList.prepareSkeleton(completion: { done in
//            self.view.showAnimatedSkeleton()
//        })
        
        setUpDependencies()
        interactor?.getMockTests(testTypeFk: testTypeFk, mockTypeFK: mockTypeFk, pageNo: nil)
        showSolidSkeleton()
    }
    
    func selectStartTest(mockTest: MockTest) {
//        if mockTest.isLocked == true {
//
//        }
//        else {
            if mockTest.testTypeFk == Constants.TEST_TYPE_WRITING {
                let vc = SelectWritingTypeViewController()
                vc.modalPresentationStyle = .overCurrentContext
                vc.buttonAction = {
                    var writingTypeName = Constants.WRITING_TYPE_UPLOAD
                    if vc.group.selectedCheckBox!.tag == 0 {
                        writingTypeName = Constants.WRITING_TYPE_WRITE
                    }
                    self.startTest(mockTest: mockTest, writingTypeName: writingTypeName)
                }
                self.present(vc, animated: false)
            } else {
                startTest(mockTest: mockTest, writingTypeName: nil)
            }
//        }
    }
    
    func startTest(mockTest: MockTest, writingTypeName: String?) {
        self.mockTest = mockTest
        self.writingTypeName = writingTypeName
        interactor?.startTest(mockTestFK: mockTest.recordNo, writingTypeName: writingTypeName)
        startAnimating(size, message: "Starting test...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
    }
    
    func hideSkeleton() {
        view.hideSkeleton()
    }
        
    func showSolidSkeleton() {
        view.showAnimatedSkeleton(usingColor: UIColor.blue, transition: .crossDissolve(0.25))
    }
   
}

extension TestListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mockTests.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MockTestCell
        cell.mockTest = self.mockTests[indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        selectStartTest(mockTest: self.mockTests[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 2
        let padding:CGFloat = 20
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - padding
        let itemHeight = collectionView.bounds.height - (2 * padding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension TestListViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
