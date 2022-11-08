//
//  ListView.swift
//  Demo
//
//  Created by m_quadra on 2022/9/20.
//

import UIKit
import MQKit

class ListView: UIView {
    required init?(coder: NSCoder) { return nil }
    
    fileprivate let layout = UICollectionViewCompositionalLayout { idx, env in
        let item = NSCollectionLayoutItem(layoutSize: .width(.estimated(20)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .height(.estimated(20)),
            subitems: [item]
        )
        group.interItemSpacing = .flexible(5)
        group.contentInsets = .horizontal(5)
        
        let section = group.section
        section.interGroupSpacing = 5
        return section
    }
    fileprivate lazy var collectionView = dsl(for: UICollectionView(layout: self.layout)) { make in
        make.backgroundColor(.clear)
        
        guard let collectionView = make.object else { return }
        
        collectionView.register(cells: [
            Cell.self
        ])
    }
    
    lazy var dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
        let cell: Cell = collectionView.dequeue(for: indexPath)
        cell.textLabel.text = itemIdentifier
        return cell
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
