//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mike Horn on 9/4/15.
//  Copyright (c) 2015 Mike Horn. All rights reserved.
//

import Foundation
// The ChecklistItem object currently only serves to combine the text and the checked flag into one object. 

class ChecklistItem {
  var text = ""
  var checked = false
  
  func toggleChecked() {
    checked = !checked
  }
}


