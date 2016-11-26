//
//  AllCategoriesTableViewDataSource.swift
//  AndysToDo
//
//  Created by dillion on 12/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AllCategoriesTableViewDataSource : NSObject, UITableViewDataSource {
    
    // View Model
    
    var viewModel : AllCategoriesViewModel?
    
    init(viewModel : AllCategoriesViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel!.categories!.value.count
        case 1:
            return viewModel!.timeCategories!.value.count
        case 2:
            return 2
            
        default:
            print("Something went wrong in number of sections")
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.main_storyboard_category_table_view_cell_id, for: indexPath) as! CategoryTableViewCell
            cell.textLabel?.text = viewModel!.categories!.value[indexPath.row].value.Name!
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.main_storyboard_timecat_table_view_cell_id, for: indexPath) as! TimecatTableViewCell
            cell.name_lbl.text = viewModel!.timeCategories!.value[indexPath.row].value.Name!
            cell.time_lbl.text = "\(TimeConverter.convertFloatToTimeString(_time: viewModel!.timeCategories!.value[indexPath.row].value.StartOfTimeWindow!))-\(TimeConverter.convertFloatToTimeStringWithMeridian(_time: viewModel!.timeCategories!.value[indexPath.row].value.EndOfTimeWindow!))"
            if let _ = viewModel!.timeCategories!.value[indexPath.row].value.color {
                cell.backgroundColor = UIColor(cgColor: viewModel!.timeCategories!.value[indexPath.row].value.color!)
            }
            return cell
        case 2:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.textLabel?.text = Constants.allCategoriesVC_category_cell_title
                return cell
            case 1:
                let cell = UITableViewCell()
                cell.textLabel?.text = Constants.allCategoriesVC_timecat_cell_title
                return cell
            default:
                print("Something went wrong in cell for row")
                return UITableViewCell()
            }
        default:
            print("Something went wrong in cell for row")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Constants.allCategoriesVC_category_table_header
        case 1:
            return Constants.allCategoriesVC_timecat_table_header
        case 2:
            return Constants.allCategoriesVC_create_table_header
        default:
            print("Something went wrong in title for header")
            return ""
        }
    }
}
