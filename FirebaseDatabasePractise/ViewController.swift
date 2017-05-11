

// jaha comments hai please check those areas.!

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    
    fileprivate var ref:FIRDatabaseReference!
    var data = [Data]()
    fileprivate var isInitialLoaded:Bool = false //ye check karega if .value is loaded or not
    
    //bad indentation :-p
        lazy var myTableView : UITableView = {
            var view = UITableView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.delegate = self
            view.dataSource = self
            
            
            return view
        }()
        override func viewDidLoad() {
            super.viewDidLoad()
             setupView()
            getData1()
            getData2()
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
    

    func getData1(){
        ref = FIRDatabase.database().reference()

        //this is the initial load.
        ref.child("colorsArray").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in //MEMORY LEAK
            
            guard let strongSelf = self else { return }

            let download = snapshot.children.allObjects as! [FIRDataSnapshot] //its an array of data snapshots
            strongSelf.data = download.map({ //deal with one single snapshot represented by $0
                
                return strongSelf.dataObject(sample: $0)
            })
            
        
            DispatchQueue.main.async { // update the tableview on the main thread only ye download side thread pe hota hai
                strongSelf.myTableView.reloadData()
                strongSelf.isInitialLoaded = true
            }
        
        })
    }
    
    func getData2(){
        
        if isInitialLoaded {
            
            
            ref.child("colorsArray").observe(.childAdded, with: { [weak self] snapshot in
                guard let strongSelf = self else {return}
                strongSelf.data.append(strongSelf.dataObject(sample: snapshot))
               
                DispatchQueue.main.async {
                    strongSelf.myTableView.insertRows(at: [IndexPath(row:strongSelf.data.count-1,section:0)], with: .left)
                }
            })
            
            
//            ref.child("colorsArray").observe(.childRemoved, with: {[weak self] snapshot in
//            
//                guard let strongSelf = self else {return}
//                
//            })
//            
//            
//            ref.child("colorsArray").observe(.childChanged, with: {[weak self] snapshot in
//            
//                guard let strongSelf = self else {return}
//            
//            
//            })
            
            
            
            
            
        }
        
        
    }
    
    
    func dataObject(sample:FIRDataSnapshot) -> Data
    {
        if let snap = sample.value as? Dictionary<String,String>
        {
            let object = Data(colorName: snap["colorName"], hexValue: snap["hexValue"],key:sample.key)
            return object
        }
        return Data()
    }
}
    
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = data[indexPath.row].colorName
        cell.detailTextLabel?.text = data[indexPath.row].hexValue
        
        return cell
    }
}
    



