//
//  ViewController.swift
//  Demo
//
//  Created by m_quadra on 2022/8/19.
//

import UIKit
import SnapKit
import MQHandwritingRecognition
import MQKit

class ViewController: UIViewController {
    
    fileprivate let listView = ListView()
    fileprivate lazy var drawView: DrawView = dsl { make in
        make.backgroundColor(.lightGray)
        
        guard let drawView = make.object else { return }
        
        drawView.strokesDidChange { [weak self] strokes in
            guard let self = self else { return }
            
            Task { @MainActor in
                let arr = await byRecognition(strokes: strokes)
                
                var snapshot = self.listView.dataSource.emptySnapshot
                snapshot.appendSections([0])
                snapshot.appendItems(arr, toSection: 0)
                self.listView.dataSource.apply(snapshot)
            }
        }
    }
    fileprivate lazy var resetButton: UIButton = dsl { make in
        make.backgroundColor(.darkGray)
            .setTitle("Reset", for: .normal)
            .addAction(handler: { [weak self] act in
                self?.drawView.reset()
            }, for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubviews([
            self.listView,
            self.resetButton,
            self.drawView,
        ])
        
        self.listView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.resetButton.snp.top)
        }
        
        self.resetButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.drawView.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        self.drawView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(drawView.snp.width)
        }
    }
}
