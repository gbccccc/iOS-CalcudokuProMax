//
//  MyTableViewController.swift
//  Calcudoku-Collection
//
//  Created by cofincup on 2024/1/12.
//

import UIKit

@IBDesignable class VolumeTableViewController: UITableViewController {
    
    @IBInspectable var calcudokuSize: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusingCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "Vol. \(indexPath.row + 1)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionToDifficulty(section: section)
    }

    func sectionToDifficulty(section: Int) -> String {
        switch section {
            case 0:
                return "Beginner"
            case 1:
                return "Easy"
            case 2:
                return "Med"
            case 3:
                return "Hard"
            case 4:
                return "Mixed"
            default:
                return "Else"
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toBookMenu" {
            let bookTableViewController = segue.destination as! BookTableViewController
            bookTableViewController.calcudokuSize = self.calcudokuSize
            
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            bookTableViewController.difficulty = self.sectionToDifficulty(section: indexPath!.section)
            bookTableViewController.volumeIndex = indexPath!.row + 1
        }
    }
    

}
