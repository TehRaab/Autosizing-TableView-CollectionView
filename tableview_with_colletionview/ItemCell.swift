//
//  ItemCell.swift
//  tableview_with_colletionview
//
//  Created by Robert Hills on 04/03/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    fileprivate var isCategory: Bool = true
    fileprivate var imageHeightRatio: CGFloat = 1
    fileprivate var cellType: String = "football"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        NSLayoutConstraint.activate(contentViewConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() { //This prevents images/text etc being reused on another cell (wrong image/text displayed)
        super.prepareForReuse()
        
        mediaPoster.deactivateAllConstraints()
        titleLabel.deactivateAllConstraints()
        
        mediaPoster.image = UIImage()
        titleLabel.text = ""
    }
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Title Text"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mediaPoster: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false //call this so image is added to view
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        return imageView
    }()
    
    func setupViews(asCategory category: Bool, withImageRatio ratio: CGFloat, cellType: String? = "football") {
        isCategory = category
        imageHeightRatio = ratio
        if let type = cellType {
            self.cellType = type
        }
        
        clipsToBounds = true
        
        addSubview(mediaPoster)
        addSubview(titleLabel)
        
        if isCategory { //text is bottom left corner of poster
            let cellSize = Utils.getCellImageSize(mediaType: "category")
            
            let posterConstraints = [
                mediaPoster.topAnchor.constraint(equalTo: self.topAnchor),
                mediaPoster.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mediaPoster.heightAnchor.constraint(equalToConstant: cellSize.height),
                mediaPoster.widthAnchor.constraint(equalToConstant: cellSize.width),
                mediaPoster.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                mediaPoster.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ]
            NSLayoutConstraint.activate(posterConstraints)
            
            let titleConstraints = [
                titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
                titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
                titleLabel.heightAnchor.constraint(equalToConstant: 20)
            ]
            NSLayoutConstraint.activate(titleConstraints)
        }
        else { //text is under the poster
            let cellSize = Utils.getCellImageSize(mediaType: self.cellType)
            
            let posterConstraints = [
                mediaPoster.topAnchor.constraint(equalTo: self.topAnchor),
                mediaPoster.widthAnchor.constraint(equalToConstant: cellSize.width),
                mediaPoster.heightAnchor.constraint(equalToConstant: cellSize.height),
                mediaPoster.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mediaPoster.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                ]
            NSLayoutConstraint.activate(posterConstraints)
            
            
            let titleConstraints = [
                titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                titleLabel.topAnchor.constraint(equalTo: mediaPoster.bottomAnchor, constant: 5),
                titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 35),
                titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
            NSLayoutConstraint.activate(titleConstraints)
        }
    }
}

extension UIView {
    func addSubViews(withList views: [UIView]) -> Void {
        for view in views {
            self.addSubview(view)
        }
    }
    
    //Remove Constraints
    func removeConstraints() {
        removeConstraints(constraints)
    }
    
    func deactivateAllConstraints() {
        NSLayoutConstraint.deactivate(getAllConstraints())
    }
    
    func getAllSubviews() -> [UIView] {
        return UIView.getAllSubviews(view: self)
    }
    
    func getAllConstraints() -> [NSLayoutConstraint] {
        
        var subviewsConstaints = getAllSubviews().flatMap { (view) -> [NSLayoutConstraint] in
            return view.constraints
        }
        
        if let superview = self.superview {
            
            subviewsConstaints += superview.constraints.compactMap { (constraint) -> NSLayoutConstraint? in
                if let view = constraint.firstItem as? UIView {
                    if view == self {
                        return constraint
                    }
                }
                return nil
            }
        }
        
        return subviewsConstaints + constraints
    }
    
    class func getAllSubviews(view: UIView) -> [UIView] {
        return view.subviews.flatMap { subView -> [UIView] in
            return [subView] + getAllSubviews(view: subView)
        }
    }
}
