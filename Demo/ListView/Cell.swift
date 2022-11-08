//
//  Cell.swift
//  Demo
//
//  Created by m_quadra on 2022/9/20.
//

import UIKit
import MQKit

class Cell: UICollectionViewCell {
    required init?(coder: NSCoder) { return nil }
    
    let textLabel: UILabel = dsl { make in
        make.textAlignment(.center)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .lightGray
        self.contentView.layer.cornerRadius = 3
        
        self.contentView.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
