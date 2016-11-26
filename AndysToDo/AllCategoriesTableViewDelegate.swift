//
//  AllCategoriesTableViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AllCategoriesTableViewDelegate : NSObject, UITableViewDelegate {
    
    // View Model
    
    var viewModel : AllCategoriesViewModel?
    
    // View Delegate
    
    weak var viewDelegate : AllCategoriesTableViewController?
    
    init(viewModel : AllCategoriesViewModel, delegate : AllCategoriesTableViewController) {
        self.viewModel = viewModel
        self.viewDelegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            viewDelegate?.pushCategoryEditView(at: indexPath.row)
        case 1:
            viewDelegate?.pushTimecatEdit(at: indexPath.row)
        case 2:
            switch indexPath.row {
            case 0:
                viewDelegate?.pushCreateCategory()
            case 1:
                viewDelegate?.pushCreateTimecat()
            default:
                print("Something went wrong in did select")
                return
            }
        default:
            print("Something went wrong in did select")
            return
        }
    }
}
