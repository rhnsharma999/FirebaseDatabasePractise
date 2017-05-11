//
//  ViewController.swift
//  FirebaseDatabasePractise
//
//  Created by Anurita Srivastava on 11/05/17.
//  Copyright © 2017 Anurita Srivastava. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
        
        lazy var myTableView : UITableView = {
            var view = UITableView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.delegate = self
            view.dataSource = self
            
            
            return view
        }()
    
    var colors = [String]()
    var hex = [String]()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.\ 
             setupView()
            getData()
            myTableView.reloadData()
        }
        
        func setupView(){
            view.addSubview(myTableView)
            myTableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
            myTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
            myTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            myTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
        
        
    }

extension ViewController{
    
    func getData(){
        var ref = FIRDatabase.database().reference()
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            let value = snapshot.value as? NSDictionary
            
            let colorsArray = value?["colorsArray"] as? [[String:Any]]
            
            for (key:color) in colorsArray! {
                
                if let colorName = color["colorName"] as? String {
                    //print(colorName)
                    self.colors.append(colorName)
                     //print(self.colors.count)
                }
                if let hexValue = color["hexValue"] as? String {
                    //print(hexValue)
                    self.hex.append(hexValue)
                }
            }
             self.myTableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    
    }
}
    
    extension ViewController: UITableViewDelegate, UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return colors.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = colors[indexPath.row]
            cell.detailTextLabel?.text = hex[indexPath.row]
            
            return cell
        }
       
        
    }
    



