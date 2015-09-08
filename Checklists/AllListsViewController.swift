//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Mike Horn on 9/8/15.
//  Copyright (c) 2015 Mike Horn. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      performSegueWithIdentifier("ShowChecklist", sender: nil)
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cellIdentifier = "Cell"
      var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell


      if cell == nil {
        cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
      }
      
        cell.textLabel!.text = "List \(indexPath.row)"
      
        return cell
    }

}
