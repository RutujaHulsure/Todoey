//
//  ViewController.swift
//  Todoey
//
//  Created by Coditas on 21/06/21.
//

import UIKit

class TodoeyViewController: UITableViewController {
    
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItem()
        
//        if let item = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = item
//        }
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var itemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item!", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = itemTextField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            itemTextField = alertTextField
            
        }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: filePath!)
        }catch{
            print("error encoding item array,\(error)")
        }
        self.tableView.reloadData()
    }
    func loadItem(){
        if let data = try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("error decoding itemarray,\(error)")
            }
        }
    }
}

