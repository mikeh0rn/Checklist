//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mike Horn on 9/4/15.
//  Copyright (c) 2015 Mike Horn. All rights reserved.
//

import Foundation
// The ChecklistItem object currently only serves to combine the text and the checked flag into one object. 

class ChecklistItem: NSObject, NSCoding {
  var text = ""
  var checked = false
  
  func toggleChecked() {
    checked = !checked
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(text, forKey: "Text")
    aCoder.encodeBool(checked, forKey: "Checked")
  }
  
  //init methods are special in Swift. Because you just added init(coder) you also need to add an init() method that takes no parameters. Without this, the app won’t build.
  
  required init(coder aDecoder: NSCoder){
    text = aDecoder.decodeObjectForKey("Text") as! String
    checked = aDecoder.decodeBoolForKey("Checked")
    super.init()
  }
  
  override init(){
    super.init()
  }
}


