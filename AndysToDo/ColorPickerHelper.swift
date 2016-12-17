//
//  ColorPickerHelper.swift
//  AndysToDo
//
//  Created by dillion on 11/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ColorPickerHelper {
    
    class func colorPicker(viewWidth : CGFloat) -> [ColorPickerButton] {
        var pickers = [ColorPickerButton]()
        var buttonWidth : CGFloat = 0.0
        var marginWidth : CGFloat = 0.0
        var xCoord : CGFloat = 0.0
        var numberOfElementsPerRow : Int = 0
        var yCoord : CGFloat = 0.0
        for i in Constants.colorPicker_row_Size_Min...Constants.colorPicker_row_Size_Max {
            if (Int(Float(viewWidth)) % i) == 0 {
                buttonWidth = CGFloat(i)
                marginWidth = CGFloat(i) * Constants.colorPicker_units_in_margins
                xCoord = marginWidth
                numberOfElementsPerRow = Int(Float(viewWidth / buttonWidth)) - Int(Constants.colorPicker_units_in_margins * 2.0)
                yCoord = Constants.timecatVC_color_label_bottom_y_coord + Constants.colorPicker_standard_view_padding
                break
            }
        }
        
        if numberOfElementsPerRow == 0 {
            print("No effective modulus")
            return pickers
        }
        let maxButtons = numberOfElementsPerRow * Constants.colorPicker_column_size
        
        let currentDenominator = Int(floor(pow(Double(maxButtons), 1/3)))
        var totalButtons = 0
        for outerIndex in 1...currentDenominator {
            for innerIndex in 1...currentDenominator {
                for cubicIndex in 1...currentDenominator {
                    let totalIndex = (outerIndex - 1) * Int(pow(Double(currentDenominator), 2.0)) + (innerIndex - 1) * currentDenominator + cubicIndex - 1
                    let button = ColorPickerButton(frame: CGRect(x: xCoord + (buttonWidth * CGFloat(totalIndex % numberOfElementsPerRow)), y: yCoord + (buttonWidth * CGFloat(totalIndex / numberOfElementsPerRow)), width: buttonWidth, height: buttonWidth), _r: 1.0 / Float(outerIndex), _g: 1.0 / Float(innerIndex), _b: 1.0 / Float(cubicIndex))
                    
                    pickers.append(button)
                    totalButtons += 1
                }
            }
        }
        return pickers
    }
}
