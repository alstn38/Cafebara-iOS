//
//  RoutineViewController.swift
//  Cafebara-iOS
//
//  Created by 강민수 on 4/8/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxDataSources
import RxSwift

final class RoutineViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: RoutineViewModel
    private let deleteSelectedID = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let routineView = RoutineView()
    
    // MARK: - Life Cycles
    
    init(viewModel: RoutineViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = routineView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindViewModel()
        setDelegate()
        setGesture()
    }
}

// MARK: - Extensions

extension RoutineViewController {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfRoutine>(
            configureCell: { (_, collectionView, indexPath, item) in
                let cell = RoutineCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
                cell.configureCell(data: item)
                cell.deleteButton.rx.tap
                    .bind { [weak self] _ in
                        guard let self = self else { return }
                        self.routineView.alertview.isHidden = false
                    }
                    .disposed(by: cell.disposeBag)
                
                return cell
            },
            configureSupplementaryView: { (_, collectionView, _, indexPath) in
                let headerView = RoutineCollectionHeaderView.dequeueReusableHeaderView(collectionView: collectionView, indexPath: indexPath)
                
                return headerView
            }
        )
        
        viewModel.outputs.routineInfo
            .bind(to: routineView.routineCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func setDelegate() {
        routineView.alertview.delegate = self
    }
    
    func setGesture() {
        routineView.navigationBar.backButtonAction = {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension RoutineViewController: AlertTappedDelegate {
    func leftButtonTapped() {
        // TODO: 삭제 viewModel 통신 구현. + 삭제 완료 토스트 뷰 구현
        print("리얼 삭제")
    }
    
    func rightButtonTapped() {
        routineView.alertview.isHidden = true
    }
}
