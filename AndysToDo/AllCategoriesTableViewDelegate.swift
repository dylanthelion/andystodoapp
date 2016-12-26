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
        case Constants.allcatVC_categories_section:
            viewDelegate?.pushCategoryEditView(at: indexPath.row)
        case Constants.allcatVC_timecats_section:
            viewDelegate?.pushTimecatEdit(at: indexPath.row)
        case Constants.allcatVC_create_section:
            switch indexPath.row {
            case Constants.allcatVC_category_row:
                viewDelegate?.pushCreateCategory()
            case Constants.allcatVC_timecat_row:
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
