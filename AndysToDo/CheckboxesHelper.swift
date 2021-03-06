//
//  CheckboxesHelper.swift
//  AndysToDo
//
//  Created by dillion on 11/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CheckboxesHelper {
    
    class func generateCheckboxesAndLabels(titles: [String], cols: Int, viewWidth: CGFloat, top_y_coord: CGFloat, startingIndex : Int = 0) -> ([CheckboxButton], [UILabel]) {
        var top_y_coord = top_y_coord
        var checkboxes = [CheckboxButton]()
        var labels = [UILabel]()
        let label_width : CGFloat = ((viewWidth / CGFloat(cols)) - (Constants.checkboxesAndLabels_label_margin * CGFloat(cols + 1))) - Constants.checkboxesAndLabels_checkbox_height_and_width
        for(index, title) in titles.enumerated() {
            let index_offset : CGFloat = CGFloat(index % cols)
            let checkbox = CheckboxButton(frame: CGRect(x: (Constants.checkboxesAndLabels_checkbox_x_coord + ((viewWidth / CGFloat(cols)) * index_offset)), y: top_y_coord, width: Constants.checkboxesAndLabels_checkbox_height_and_width, height: Constants.checkboxesAndLabels_checkbox_height_and_width))
            checkbox.setImage(UIImage(named: Constants.img_checkbox_unchecked), for: .normal)
            checkbox.tag = index + startingIndex
            let label = UILabel(frame: CGRect(x: ((Constants.checkboxesAndLabels_checkbox_x_coord + Constants.checkboxesAndLabels_checkbox_height_and_width
                + Constants.checkboxesAndLabels_label_margin) + ((viewWidth / CGFloat(cols)) * index_offset)), y: top_y_coord, width: label_width, height: Constants.checkboxesAndLabels_checkbox_height_and_width))
            label.text = title
            if index % cols == (cols - 1) {
                top_y_coord += Constants.checkboxesAndLabels_full_row_offset
            }
            checkboxes.append(checkbox)
            labels.append(label)
        }
        return (checkboxes, labels)
    }
}
