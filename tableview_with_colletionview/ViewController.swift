//
//  ViewController.swift
//  tableview_with_colletionview
//
//  Created by Robert Hills on 04/03/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tableView: SelfSizedTableView!
    var categoryItems = [CategoryContentModel]()
    let reuseIdentifier = "categorycell"
    let itemReuseId = "itemCellReuseId"
    
    //Max number of items that can be viewed in horizontal category/item view
    let MAX_CATEGORIES = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupFakeDemoData()
        
        tableView.register(CategoryRowCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("category count : \(categoryItems.count)")
        return categoryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoryRowCell
        var rowTotalItemCount = 0
        
        cell.titleLbl.text = self.categoryItems[indexPath.row].title
        
        //Register Xibs
        cell.collectionView.register(ItemCell.self, forCellWithReuseIdentifier: itemReuseId)
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
        if !categoryItems[indexPath.row].category_content.isEmpty {
            rowTotalItemCount = categoryItems[indexPath.row].category_content.count
        }
        else if !categoryItems[indexPath.row].content_media.isEmpty {
            rowTotalItemCount = categoryItems[indexPath.row].content_media.count
        }
        else {
            print("Error - No category or media content under this category!")
        }
        
        print("\(cell.titleLbl.text!) has \(rowTotalItemCount) items")
        cell.seeAllBtn.isHidden = rowTotalItemCount < MAX_CATEGORIES
        if !cell.seeAllBtn.isHidden {
            cell.seeAllBtn.tag = indexPath.row
            
            //TODO - add see all click
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !categoryItems[collectionView.tag].category_content.isEmpty {
            var categoryLimit = categoryItems[collectionView.tag].category_content.count
            print("row: \(collectionView.tag) has \(categoryLimit) items, max limit set at \(MAX_CATEGORIES)")
            if categoryLimit > MAX_CATEGORIES {
                categoryLimit = MAX_CATEGORIES
            }
            return categoryLimit
        }
        else {
            var itemLimit = categoryItems[collectionView.tag].content_media.count
            print("row: \(collectionView.tag) has \(itemLimit) items, max limit set at \(MAX_CATEGORIES)")
            if itemLimit > MAX_CATEGORIES {
                itemLimit = MAX_CATEGORIES
            }
            return itemLimit
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuseId, for: indexPath) as! ItemCell
        
        if !categoryItems[collectionView.tag].category_content.isEmpty {
//            if let title = categoryItems[collectionView.tag].category_content[indexPath.row].title {
//                cell.titleLabel.text = title
//            }
            
            cell.titleLabel.text = categoryItems[collectionView.tag].category_content[indexPath.row].title
            
            //just flip background colour for now until we drop in images
            if indexPath.row%2 == 0 {
                cell.backgroundColor = UIColor.orange
            } else {
                cell.backgroundColor = UIColor.purple
            }
            
            
            cell.setupViews(asCategory: true, withImageRatio: 1)
            
            return cell
        }
        else { //NOT CATEGORY - Must be item that links directly to a synopsis
            
            if collectionView.tag == 1 {
                switch indexPath.row {
                case 0:
                    cell.titleLabel.text = "England"
                    break
                case 1:
                    cell.titleLabel.text = "Ireland"
                    break
                case 2:
                    cell.titleLabel.text = "Scotland"
                    break
                case 3:
                    cell.titleLabel.text = "Wales"
                    break
                case 4:
                    cell.titleLabel.text = "France"
                    break
                default:
                    cell.titleLabel.text = ""
                }
            }
            else {
                switch indexPath.row {
                case 0:
                    cell.titleLabel.text = "Liverpool"
                    break
                case 1:
                    cell.titleLabel.text = "Brighton"
                    break
                case 2:
                    cell.titleLabel.text = "Portsmouth"
                    break
                case 3:
                    cell.titleLabel.text = "Aldershot"
                    break
                case 4:
                    cell.titleLabel.text = "Accrington Stanley"
                    break
                default:
                    cell.titleLabel.text = ""
                }
            }

            cell.setupViews(asCategory: false, withImageRatio: 1, cellType: "rugby_layout")
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !categoryItems[collectionView.tag].category_content.isEmpty {
            print("SELECTED A CATEGORY - Goto Grid View")
        }
        else {
            print("SELECTED AN ITEM - Goto Synopsis")
        }
    }
    
    func setupFakeDemoData() {
        //Setup row 1 of table to be a list of sport categories
        let row1 = CategoryContentModel()
        row1.title = "Sports"
        row1.type = "category"
        
        var row1content = [CategoryContentModel]()
        for index in 0...4 {
            let cell = CategoryContentModel()
            
            switch index {
            case 0:
                cell.title = "Football"
                break
            case 1:
                cell.title = "Rugby"
                break
            case 2:
                cell.title = "Korfball"
                break
            case 3:
                cell.title = "Surfing"
                break
            case 4:
                cell.title = "Stand Up Paddle Boarding"
                break
            default:
                cell.title = ""
            }
            
            cell.type = "category"
            
            row1content.append(cell)
        }
        row1.category_content = row1content
        categoryItems.append(row1)
        
        
        //Setup row 2 of table to be a list of teams in a sport (team id's)
        let row2 = CategoryContentModel()
        row2.title = "Rugby"
        row2.type = "rugby_layout"
        row2.content_media = [23, 72, 1, 32, 8] //team id's
        categoryItems.append(row2)
        
        
        //Setup row 2 of table to be a list of teams in a sport (team id's)
        let row3 = CategoryContentModel()
        row3.title = "Football"
        row3.type = "football_layout"
        row3.content_media = [23, 72, 1, 32, 8] //team id's
        categoryItems.append(row3)
    }
}

