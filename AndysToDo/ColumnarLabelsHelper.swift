//
//  ColumnarLabelsHelper.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ColumnarLabelsHelper {
    
    class func columnarLabels(titles: [String], cols: Int, viewWidth: CGFloat, top_y_coord: CGFloat, startingIndex : Int = 0) -> [UILabel] {
        var labels = [UILabel]()
        var top_y_coord = top_y_coord
        let label_width : CGFloat = ((viewWidth / CGFloat(cols)) - (Constants.labelHelper_label_margin * CGFloat(cols + 1)))
        for(index, _title) in titles.enumerated() {
            let index_offset : CGFloat = CGFloat(index % cols)
            let label = UILabel(frame: CGRect(x: Constants.labelHelper_label_margin + (index_offset * (label_width + Constants.labelHelper_label_margin)), y: top_y_coord, width: label_width, height: Constants.labelHelper_lblHeight))
            label.text = _title
            if index % cols == (cols - 1) {
                top_y_coord += Constants.labelHelper_full_row_offset
            }
            labels.append(label)
        }
        
        return labels
    }
}
