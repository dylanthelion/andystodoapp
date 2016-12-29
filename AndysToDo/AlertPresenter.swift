//
//  AlertPresenter.swift
//  AndysToDo
//
//  Created by dillion on 12/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

protocol AlertPresenter {
    
    var completionHandlers : [() -> Void] { get set }
    var alertIsVisible : Bool { get set }
    func handleWillDisappear()
}
