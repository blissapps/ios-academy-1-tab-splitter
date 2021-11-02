//
//  LoadingViewController.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 22/10/2021.
//
import Foundation
import SnapKit
import UIKit
import test

public class LoadingViewController: UIViewController {
    weak var coordinator: CoordinatorProtocol?
    
    let apiClient = ApiClient()
    
    var latest: LatestDto?
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .large)
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.backgroundColor = .white
        activityIndicatorView.snp.makeConstraints { v in
            v.center.equalToSuperview()
            
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicatorView.startAnimating()
        apiClient.getLatest { [weak self] latest in
            self?.latest = latest
            try? AmountValue.initialize(currencyCode: latest.base, rates: latest.rates)
            self?.coordinator?.start()
        }
    }
    
    
}
