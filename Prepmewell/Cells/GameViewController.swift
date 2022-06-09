//
//  GameViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 30/03/2022.
//

import UIKit
import SkeletonView
import NVActivityIndicatorView

protocol GameDisplayLogic {
    func displayQuestionGroup(response: ListResponse<GameQuestionGroup>)
    func startGameResponse(response: ListResponse<TestResult>)
    func displayError(alert: String)
    func displayGames(gamesResponse: ListResponse<Game>)
}

class GameViewController: UIViewController, GameDisplayLogic, NVActivityIndicatorViewable {
    
    func displayQuestionGroup(response: ListResponse<GameQuestionGroup>) {
        stopAnimating()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ScreenID.GAME_PLAY) as! GamePlayViewController
        vc.gameTestResult = self.gameTestResult!
        vc.gameQuestionGroup = response.response[0]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func startGameResponse(response: ListResponse<TestResult>) {
        stopAnimating()
        gameTestResult = response.response[0]
        interactor?.getQuestionGroup(mockTestFK: mockTestFK!)
    }
    
    func displayError(alert: String) {
        stopAnimating()
        handleErrorMessage(message: alert)
    }
    
    func displayGames(gamesResponse: ListResponse<Game>) {
        hideSkeleton()
        stopAnimating()
        games.removeAll()
        games.append(contentsOf: gamesResponse.response)
        collectionView.reloadData()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var interactor : GameBusinessLogic?
    let reuseIdentifier = "gameCellView"
    private let sectionInsets = UIEdgeInsets(
      top: 15.0,
      left: 15.0,
      bottom: 15.0,
      right: 15.0)
    let size = CGSize(width: 80, height: 80)
    private let itemsPerRow: CGFloat = 2

    
    var games: [Game] = []
    var mockTestFK: Int?
    var gameTestResult: TestResult?
    
    func setUpDependencies() {
        let interactor = GameInteractor()
        let worker = GameWorker()
        let presenter = GamePresenter()
        let networkClient = PrepmewellApiClient()
       
        interactor.worker = worker
        interactor.presenter = presenter
       
        worker.networkClient = networkClient
       
        presenter.view = self
       
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isSkeletonable = true
        
        setUpDependencies()
        interactor?.getGames()
        showSolidSkeleton()
    }
    
    func hideSkeleton() {
        view.hideSkeleton()
    }
        
    func showSolidSkeleton() {
        self.startAnimating(self.size, message: "Fetching menu...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        view.showAnimatedSkeleton(usingColor: UIColor.blue, transition: .crossDissolve(0.25))
    }
    
    func showInstructions(mockTestFK: Int) {
        let vc = InstructionsModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.heading = "Instructions"
        vc.body = "You have just 10 seconds to answer each question. Choose the word that best defines the provided word. The faster you answer each question, the higher your score."
        vc.buttonText = "START GAME"
        vc.buttonAction = {
            self.mockTestFK = mockTestFK
            self.interactor?.startGame(mockTestFK: mockTestFK)
            self.startAnimating(self.size, message: "Starting game...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        }
        self.present(vc, animated: false)
    }

}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.games.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GameCellView
        cell.game = self.games[indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = self.games[indexPath.row]
        switch (game.testName) {
            case "IELTS Tips" :
                performSegue(withIdentifier: "gamesToTips", sender: nil)
                break
            default:
                showInstructions(mockTestFK: game.mockTestFK)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 2
        let padding:CGFloat = 8
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - padding
        //let itemHeight = 170
        return CGSize(width: itemWidth, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
            collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
}

extension GameViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
