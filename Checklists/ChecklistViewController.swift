//
//  ViewController.swift
//  Checklists
//
//  Created by Mike Horn on 9/4/15.
//  Copyright (c) 2015 Mike Horn. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
  //This tells the compiler that ChecklistViewController now promises to do the things from the AddItemViewControllerDelegate protocol.
  // the two methods below are the methods where I've shifted responsibility to the delegate.
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
    
    let newRowIndex = items.count
    
    items.append(item)
    
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
    dismissViewControllerAnimated(true, completion: nil)
    
    saveChecklistItems()
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
    
    if let index = find(items, item) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath){
        configureTextForCell(cell, withChecklistItem: item)
      }
  }
  
    dismissViewControllerAnimated(true, completion: nil)
    saveChecklistItems()
  }
  
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
    return paths[0]
  }
  
  //store the checklist items
  func dataFilePath() -> String {
    let directory = documentsDirectory()
    return directory.stringByAppendingPathComponent("Checklists.plist")
    
  }
  
  func saveChecklistItems(){
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(items, forKey: "ChecklistItems")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddItem" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! ItemDetailViewController
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let navigationController = segue.destinationViewController as! UINavigationController
      
      let controller = navigationController.topViewController as! ItemDetailViewController
      
      controller.delegate = self
      
      if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell){
        controller.itemToEdit = items[indexPath.row]
      }
    }
  }
  
  var items: [ChecklistItem]

  //customary to place the required init right below the instance variables:
  // If you can’t give the variable a value right away when you declare it, then you have to give it a value inside a so-called initializer method.
  
  //The init method is called by Swift when the object comes into existence.
  
  required init(coder aDecoder: NSCoder){
    
    //first instantiate the array object - this means an array of ChecklistItem objects. The parentheses () tell Swift to construct the new array object
    //The parentheses tell Swift’s object factory, “Build me an object of the type array- with-ChecklistItems.”
    
    items = [ChecklistItem]()
    
    // this instantiates a new ChecklistItem object. Notice the ().
    let row0item = ChecklistItem()
    row0item.text = "Walk the dog"
    row0item.checked = false
    // This adds the ChecklistItem object into the items array.
    items.append(row0item)
    
    let row1item = ChecklistItem()
    row1item.text = "Brush my teeth"
    row1item.checked = true
    items.append(row1item)
    
    let row2item = ChecklistItem()
    row2item.text = "Learn iOS Development"
    row2item.checked = true
    items.append(row2item)
    
    let row3item = ChecklistItem()
    row3item.text = "Soccer practice"
    row3item.checked = false
    items.append(row3item)
    
    let row4item = ChecklistItem()
    row4item.text = "Eat ice cream"
    row4item.checked = true
    items.append(row4item)
    
    super.init(coder: aDecoder)
    loadChecklistItems()
    
    println("Documents folder is \(documentsDirectory())")
    println("Data file path is \(dataFilePath())")
  
  }
  
  func loadChecklistItems(){
    let path = dataFilePath()
    
    if NSFileManager.defaultManager().fileExistsAtPath(path){
      if let data = NSData(contentsOfFile: path){
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        items = unarchiver.decodeObjectForKey("ChecklistItems") as! [ChecklistItem]
        unarchiver.finishDecoding()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // Remember this well: the rows are the data, the cells are the views. The table view controller is the thing that ties them together through the act of implementing the table view’s data source and delegate methods.
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // return 1 tells the tableView that you have just 1 row of data
    // the caller is the UITableView object and it wants to know how many rows are in the table
    // now that the tableView knows it ONLY has x rows bc of the return items.count, it calls the 2nd method cellForRowAtIndexPath to obtain a cell for that row
    return items.count
    // HEY table, we're gonna have 5 rows. SO now the table will tell cellForRowAtIndexPath message 5 times, once per row.
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //NSIndexPath is simply an object that points to a specifc row in the table
    
    
    let cell =
          tableView.dequeueReusableCellWithIdentifier("ChecklistItem")
                    as! UITableViewCell
    // a call to tableView.dequeueReusableCellWithIdentifier()- This makes a new copy of the prototype cell if necessary or recycles an existing cell that is no longer in use. it puts it in a local constant named cell.
    
    //A tag is a numeric identifier that you can give to a user interface control in order to easily look it up later. it returns a references to the UILabel object
    // Using tags is a handy trick to get a reference to a UI element without having to make an @IBOutlet variable for it.
    // There will be more than one cell in the table and each cell will have its own label. If you connected the label from the prototype cell to an outlet on the view controller, that outlet could only refer to the label from one of these cells, not all of them. Since the label belongs to the cell and not to the view controller as a whole,
    //  you can’t make an outlet for it on the view controller.
    
    // this asks the array for the ChecklistItem object at the index that corresponds to the row number
    let item = items[indexPath.row]
    
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
    
    configureTextForCell(cell, withChecklistItem: item)
    configureCheckmarkForCell(cell, withChecklistItem: item)
    
    return cell
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
    items.removeAtIndex(indexPath.row)
  
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
    saveChecklistItems()
  
  }
  
  
  //The first parameter is the UITableView object on whose behalf these methods are invoked. This is done for convenience, so you won’t have to make an @IBOutlet in order to send messages back to the table view.
  // the return type of the method is at the end, after the -> arrow. If there is no arrow, as in tableView(didSelectRowAtIndexPath), then the method is not supposed to return a value.
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //toggles the Checkmark
    //This tells Swift that you only want to perform the rest of the code if there really is a UITableViewCell object
    
   if let cell = tableView.cellForRowAtIndexPath(indexPath){
    let item = items[indexPath.row]
      item.toggleChecked()
    
      configureCheckmarkForCell(cell, withChecklistItem: item)
    }
  
    // brief turns row grey on the tableview object
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    saveChecklistItems()
  }
  
  
  //Swift allows quite a bit of flexibility in the naming of methods, but standard practice is to put the name of the first parameter into the name of the method, as in configureCheckmarkForCell(...)
  
  func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem){
    
      let label = cell.viewWithTag(1001) as! UILabel
      if item.checked {
          label.text = "√"
        } else {
          label.text = ""
      }

      
  }
  
  func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem){
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }
  


}

