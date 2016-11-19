//
//  Constants.swift
//  AndysToDo
//
//  Created by dillion on 10/13/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    // UI constants
    
    static let alpha_solid :CGFloat = 1.0
    static let alpha_faded :CGFloat = 0.3
    static let text_view_border_width : CGFloat = 2.0
    static let text_view_border_color : CGColor = UIColor.gray.cgColor
    static let standard_alert_ok_title = "Success"
    static let standard_alert_fail_title = "Failed"
    static let standard_alert_error_title = "Error"
    
    // Image names
    
    static let img_checkbox_unchecked = "checkbox_unchecked"
    static let img_checkbox_checked = "checkbox_checked"
    
    // UI reusable elements
    
    static let standard_ok_alert_action : UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    // Storyboard
    
    static let main_storyboard_id = "Main"
    static let main_tab_storyboard_id = "mainTabBarController"
    static let task_table_view_cell_id = "taskTableViewCell"
    static let create_repeatable_task_VC_id = "createRepeatableTaskVC"
    static let main_storyboard_create_category_VC_id = "createCategoryViewController"
    static let main_storyboard_create_timecat_VC_id = "createTimecatVC"
    static let main_storyboard_activeTask_VC_id = "displayActiveTaskVC"
    static let main_storyboard_inactiveTask_VC_id = "displayInactiveTaskVC"
    static let main_storyboard_add_category_VC_id = "addCategoriesVC"
    static let main_storyboard_all_tasks_individuAL_VC_ID = "allTasksIndividualVC"
    static let main_storyboard_main_tasks_VC_index = 0
    static let main_storyboard_create_tasks_VC_index = 0
    static let main_storyboard : UIStoryboard = UIStoryboard(name: main_storyboard_id, bundle:nil)
    
    // Time constants
    
    static let meridian_am = "AM"
    static let meridian_pm = "PM"
    static let seconds_per_minute : Float = 60.0
    static let hours_per_meridian : Float = 12.0
    static let standard_month_format = "MMM"
    static let standard_hours_and_minutes_format = "hh:mm"
    static let standard_full_date_format = "MMM dd hh:mm a yyyy"
    static let standard_hours_meridian_format = "hh:mm a"
    static let standard_months_and_days_format = "MMM dd"
    static let standard_days_format = "dd"
    static let months_per_year = 12
    static let days_per_month = 31
    static let total_meridians = 2
    static let days_per_week = 7
    static let seconds_per_day = 86400
    static let seconds_per_hour = 3600
    static let seconds_per_week = 604800
    static let seconds_per_month = 2592000
    static let all_months_as_strings = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"]
    static let all_days_as_strings = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    static let all_hours_as_ints = [1,2,3,4,5,6,7,8,9,10,11,12]
    static let days_of_week_as_strings = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Multiple"]
    
    // Login provider IDs
    
    static let FB_App_ID = "1828909847353965"
    static let Google_App_Id = "456850595025-deqquec64tjg1mg347akg8fj4dadv71h.apps.googleusercontent.com"
    
    // TaskDTO
    
    static let repeatablesToGenerate = 3
    
    // MainLoginVC
    
    static let login_button_width : CGFloat = 82.0
    static let login_button_height : CGFloat = 30.0
    static let button_y_position_offset : CGFloat = 10.0
    
    // Main Task VC
    static let mainTaskVC_upper_limit_calendar_unit : Calendar.Component = Calendar.Component.day
    static let mainTaskVC_upper_limit_number_of_units : Int = 1
    
    // FilterVC
    
    static let filterVC_starting_y_coord : CGFloat = 132.0
    static let filterVC_full_row_offset : CGFloat = 40.0
    static let filterVC_full_header_offset : CGFloat = 44.0
    static let filterVC_header_label_height : CGFloat = 34.0
    static let filterVC_header_font_size : CGFloat = 22.0
    static let filterVC_header_x_coord : CGFloat = 40.0
    static let filterVC_header_font_name = "Arial"
    static let filterVC_header_text_color : UIColor = UIColor.green
    static let filterVC_timecat_header_text = "Time Categories"
    
    // CreateCategoryVC
    
    static let createCatVC_alert_success_message = "Category created"
    static let createCatVC_alert_no_name_or_description_failure_message = "Please include a name and description"
    static let createCatVC_alert_name_uniqueness_failure_message = "That name is already taken"
    
    // MainCreateVC
    
    static let mainCreateVC_title = "Create Tasks"
    
    // CreateTimecatVC
    
    static let timecatVC_alert_no_name_description_or_window_failure_message = "Please include a name, description, and a full time window"
    static let timecatVC_alert_success_message = "Category created"
    static let timecatVC_alert_name_uniqueness_failure_message = "That name is already taken"
    static let timecatVC_color_label_bottom_y_coord : CGFloat = 402.0
    static let timecatVC_color_picker_selected_border_width : CGFloat = 2.0
    static let timecatVC_color_picker_deselected_border_width : CGFloat = 0.0
    static let timecatVC_color_picker_selected_border_color : CGColor = UIColor.black.cgColor
    static let timecatVC_color_picker_deselected_border_color : CGColor = UIColor.clear.cgColor
    
    // CreatTaskVC
    
    static let createTaskVC_alert_no_name_description_or_time_failure_message = "Please include a name, description, and all time information"
    static let createTaskVC_repeatable = "Repeatable"
    static let createTaskVC_alert_invalid_repeatables_failure_message = "Your information is invalid. Something went wrong with repeatables."
    static let createTaskVC_alert_success_message = "Task created"
    static let createTaskVC_alert_invalid_repeatable_information_failure_message = "Your repeatable information is invalid. Something went wrong."
    static let createTaskVC_alert_invalid_nonrepeatable_failure_message =
        "Your normal information is invalid. Something went wrong."
    
    // AddCategoriesVC
    
    static let addCatVC_starting_y_coord : CGFloat = 80.0
    static let addCatVC_label_x_coord : CGFloat = 70.0
    static let addCatVC_button_x_coord : CGFloat = 30.0
    static let addCatVC_label_width : CGFloat = 200.0
    static let addCatVC_button_width : CGFloat = 30.0
    static let addCatVC_item_height : CGFloat = 30.0
    static let addCatVC_row_diff : CGFloat = 40.0
    
    // CreateRepeatableVC
    
    static let createRepeatableVC_alert_invalid_failure_message = "Your repeatable is invalid"
    static let createRepeatableVC_alert_no_unitOfTime_failure_message = "Choose a unit of time"
    static let createRepeatableVC_alert_nonnumeric_numberOfUnits_value_failure_message = "Please enter a number in units per task. This is the number of hours, days, or weeks, between scheduled tasks"
    static let createRepeatableVC_alert_missing_data_failure_message = "Please fill out all visible fields"
    static let createRepeatableVC_repeatable = "Repeatable"
    static let createRepeatableVC_starting_checkboxes_y_coord : CGFloat = 396.0
    static let createRepeatableVC_checkbox_left_padding : CGFloat = 10.0
    static let createRepeatableVC_checkbox_right_padding : CGFloat = 20.0
    static let createRepeatableVC_lbl_left_padding : CGFloat = 10.0
    static let createRepeatableVC_checkbox_width : CGFloat = 30.0
    static let createRepeatableVC_checkbox_row_height : CGFloat = 50.0
    
    // DisplayAllTasksVC
    
    static let displayAllTasksVC_string_repeatable = "Repeatable"
    static let displayAllTasksVC_string_no_time = "No time"
    static let main_storyboard_display_task_table_view_cell_id = "allTasksTableViewCell"
    
    // AllTasksIndividualTaskVC
    
    static let allTasksIndividualTaskVC_btn_title_child_task = "child task"
    static let allTasksIndividualTaskVC_btn_title_temp_copy = "temp copy task"
    static let allTasksIndividualTaskVC_alert_message_missing_child_details = "Please include a start time for your child task"
    
    // AllCategoriesTableVC
    
    static let main_storyboard_category_table_view_cell_id = "categoryTableViewCell"
    static let main_storyboard_timecat_table_view_cell_id = "timecatTableViewCell"
    static let allCategoriesVC_category_cell_title = "Category"
    static let allCategoriesVC_timecat_cell_title = "Timecat"
    static let allCategoriesVC_category_table_header = "Categories"
    static let allCategoriesVC_timecat_table_header = "Timecats"
    static let allCategoriesVC_create_table_header = "Create:"
    
    // DisplayArchivedTaskVC
    
    static let displayArchivedTaskVC_categories_lbls_top_y_coord : CGFloat = 499.0
    
    // Helper views
    
    // Checkboxes and labels
    
    static let checkboxesAndLabels_checkbox_x_coord : CGFloat = 10.0
    static let checkboxesAndLabels_full_row_offset : CGFloat = 40.0
    static let checkboxesAndLabels_checkbox_height_and_width : CGFloat = 30.0
    static let checkboxesAndLabels_label_margin : CGFloat = 10.0
    
    // Label helper
    
    static let labelHelper_label_margin : CGFloat = 10.0
    static let labelHelper_lblHeight : CGFloat = 21.0
    static let labelHelper_full_row_offset : CGFloat = 40.0
    
    // Color Picker
    
    static let colorPicker_units_in_margins : CGFloat = 3.0
    static let colorPicker_standard_view_padding : CGFloat = 10.0
    static let colorPicker_column_size : Int = 11
    
    // Time picker views
    
    static let picker_minutes_per_hour = 12
    static let total_unitsOfTime = 3
    static let picker_all_minutes_as_ints = [00,05,10,15,20,25,30,35,40,45,50,55]
    
    // TaskTableViewCellOnItButton
    
    static let taskTableViewCell_onIt = "ON IT!"
    static let taskTableViewCell_done = "DONE"
    
    // Enums
    
    static let timeOfDay_daily_value = "Daily"
    static let timeOfDay_hourly_value = "Hourly"
    static let timeOfDay_weekly_value = "Weekly"
    static let dayOfWeek_all = [DayOfWeek.Sunday, DayOfWeek.Monday, DayOfWeek.Tuesday, DayOfWeek.Wednesday, DayOfWeek.Thursday, DayOfWeek.Friday, DayOfWeek.Saturday]
    static let totalExpectedUnitsOfTime = 5
    static let expectedUnitOfTime_All = [UnitOfTime.Minute, UnitOfTime.Hour, UnitOfTime.Day, UnitOfTime.Week, UnitOfTime.Month]
    static let expectedUnitsOfTimeAsString = ["Minutes", "Hours", "Days", "Weeks", "Months"]
}
