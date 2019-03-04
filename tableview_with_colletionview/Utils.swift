//
//  Utils.swift
//  tableview_with_colletionview
//
//  Created by Robert Hills on 04/03/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func getCellImageSize(mediaType: String) -> CGSize {
        print("getCellImageSize(mediaType: \(String(describing: mediaType)))")
        var itemWidth = 100
        var itemHeight = 100
        
        switch mediaType {
        case "category":
            itemWidth = 227
            itemHeight = 147
            break;
        case "rugby_layout":
            itemWidth = 100
            itemHeight = 200
            break;
        case "football_layout":
            itemWidth = 100
            itemHeight = 100
            break;
        default:
            print("getCellImageSize() - unknown media type \(mediaType)")
        }
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
