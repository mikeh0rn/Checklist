//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Mike Horn on 9/7/15.
//  Copyright (c) 2015 Mike Horn. All rights reserved.
//

import UIKit

//This defines the ItemDetailViewControllerDelegate protocol. You should recognize the lines inside the protocol { ... } block as method declarations, but unlike other methods they don’t have any source code in them. The protocol just lists the names of the methods.
//Think of the delegate protocol as a contract between screen B and any screens that wish to use it.

protocol ItemDetailViewControllerDelegate: class{
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
  // Recall that viewDidLoad() is called by UIKit when the view controller is loaded from the storyboard, but before it is shown on the screen. That gives you time to put the user interface in order.
  override func viewDidLoad(){
    super.viewDidLoad()
    tableView.rowHeight = 44
    
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      doneBarButton.enabled = true
    }
  }
  
  //There are a few other ways to read the value of an optional, but using if let is the safest: if the optional has no value – i.e. it is nil – then the code inside the if let block is skipped over.
  
  
  @IBOutlet weak var textField: UITextField!
  
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  weak var delegate: ItemDetailViewControllerDelegate?
  
  var itemToEdit: ChecklistItem?
  
  //Delegates are usually declared as being weak – not a statement of their moral character but a way to describe the relationship between the view controller and its delegate – and optional (the question mark).
  
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
    // When the user taps the Cancel button, you send the ItemDetailViewControllerDidCancel() message back to the delegate.
  }
  
  @IBAction func done(){
    
    if let item = itemToEdit {
      item.text = textField.text
      delegate?.itemDetailViewController(self, didFinishEditingItem: item)
    } else {
      let item = ChecklistItem()
      item.text = textField.text
      item.checked = false
      delegate?.itemDetailViewController(self, didFinishAddingItem: item)
    }
  }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  // invoked every time the user changes the text by tapping on the keyboard or cut/paste
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    // first figure out what the new text with be
    let oldText: NSString = textField.text
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    //The textField(shouldChangeCharactersInRange) delegate method doesn’t give you the new text, only which part of the text should be replaced (the range) and the text it should be replaced with (the replacement string).
    // You need to calculate what the new text will be by taking the text field’s text and doing the replacement yourself. This gives you a new string object that you store in the newText constant.
    
    doneBarButton.enabled = (newText.length > 0)
    println(newText.length > 0)
    return true
  }
}
