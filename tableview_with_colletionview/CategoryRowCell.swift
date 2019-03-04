//
//  CategoryRowCell.swift
//  tableview_with_colletionview
//
//  Created by Robert Hills on 04/03/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class CategoryRowCell: UITableViewCell {
    let titleLbl = UILabel()
    let seeAllBtn = UIButton(type: .custom)
    lazy var horizontalLayout: UICollectionViewFlowLayout = {
        let tmpLayout = UICollectionViewFlowLayout()
        let width = bounds.size.width //should adjust for inset
        tmpLayout.estimatedItemSize = CGSize(width: width, height: 100)
        tmpLayout.scrollDirection = .horizontal
        return tmpLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: horizontalLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.bounces = false
        collection.collectionViewLayout = horizontalLayout
        collection.isScrollEnabled = true
        collection.backgroundColor = .clear
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupCategoryViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLbl.text = ""
        seeAllBtn.removeTarget(nil, action: nil, for: .allEvents)
        collectionView.setContentOffset(.zero, animated: false)
    }
    
    func setupCategoryViews() {
        //First configure all views and then setup the constraints..
        
        //Clear background colour
        backgroundColor = UIColor.clear
        
        //Category Title
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 1
        titleLbl.textAlignment = .left
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLbl)
        
        //See All
        seeAllBtn.titleLabel?.textColor = .white
        seeAllBtn.setTitle("See All", for: .normal)
        seeAllBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(seeAllBtn)
        
        //Collection View
        addSubview(collectionView)
        
        
        //Now views are setup, lets add the constraints..
        let titleConstraints = [
            titleLbl.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLbl.heightAnchor.constraint(lessThanOrEqualToConstant: 30)
        ]
        NSLayoutConstraint.activate(titleConstraints)
        
        let seeAllBtnConstraints = [
            seeAllBtn.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant: 16),
            seeAllBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            seeAllBtn.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor)
        ]
        NSLayoutConstraint.activate(seeAllBtnConstraints)
        
        
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            collectionView.heightAnchor.constraint(equalToConstant: 250)
            //collectionView.heightAnchor.constraint(equalToConstant: collectionView.collectionViewLayout.collectionViewContentSize.height)
        ]
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
}
