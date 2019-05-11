//
//  ViewController03.swift
//  MyNailsApp
//
//  Created by mac on 09/05/19.
//  Copyright © 2019 mac. All rights reserved.
//


import UIKit
import FirebaseDatabase
import Firebase

class ViewController03: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var refStores: DatabaseReference!
    
    @IBOutlet weak var txtStore: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tblStores: UITableView!
    //@IBOutlet weak var txtProduct: UITextField!
    //@IBOutlet weak var txtPrice: UITextField!
    //@IBOutlet weak var labelMessage: UILabel!
    //@IBOutlet weak var tblProducts: UITableView!
    
    
    
    
    
    var StoresList = [StoreModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Store = StoresList[indexPath.row]
        print(Store.id!)
        let alertController = UIAlertController(title:Store.Store, message:"Give me values to update Store", preferredStyle:.alert)
        
        let updateAction =  UIAlertAction(title: "Update", style:.default){(_) in
            
            //Checar el Id que no almacena los datos
            let id = Store.id
            
            let Store = alertController.textFields?[0].text
            let Phone = alertController.textFields?[1].text
            
            self.updateStore(id: id!, Store: Store!, Phone: Phone!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style:.default){(_) in
            self.deleteStore(id: Store.id!)
        }
        
        alertController.addTextField{(textField) in textField.text = Store.Store
            
        }
        
        alertController.addTextField{(textField) in textField.text = Store.Phone
            
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
    }
    
    func updateStore(id: String, Store: String, Phone: String){
        let Store = ["id": id, "StoreName": Store, "StorePhone": Phone]
        
        refStores.child(id).setValue(Store)
        labelMessage.text = "Store Updated"
        listStores()
    }
    
    func deleteStore(id:String){
        refStores.child(id).setValue(nil)
        listStores()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoresList.count
    }
    
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! TableViewCell03
        
        let Stores: StoreModel
        
        Stores = StoresList[indexPath.row]
        
        cell.lblStore.text = Stores.Store
        cell.lblPhone.text = Stores.Phone
        
        return cell
    }
    
    //@IBAction func ButtonAddPiano(_ sender: UIButton) {
    
    //@IBAction func ButtonAddInstrument(_ sender: UIButton) {
    
    
    
    @IBAction func ButtonAddStores(_ sender: UIButton) {
        
    
        addStore()
        
        txtStore.text = "";
        txtPhone.text = "";
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Use Firebase library to configure APIs
        if FirebaseApp.app() == nil{
            FirebaseApp.configure()
        }
        
        refStores = Database.database().reference().child("Store");
        listStores()
    }
    func listStores(){
        refStores.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>=0{
                self.StoresList.removeAll()
                
                for Stores in snapshot.children.allObjects as![DataSnapshot]{
                    let StoreObject = Stores.value as? [String: AnyObject]
                    let StoreName = StoreObject?["StoreName"]
                    let StorePhone = StoreObject?["StorePhone"]
                    let StoreId = StoreObject?["id"]
                    
                    let Store = StoreModel(id: StoreId as! String?, Store: StoreName as! String?, Phone: StorePhone as! String?)
                    self.StoresList.append(Store)
                }
                
                self.tblStores.reloadData()
            }
        })
        
        
    }
    
    func addStore(){
        let key = refStores.childByAutoId().key
        
        let Stores = ["id":key,"StoreName": txtStore.text! as String,"StorePhone": txtPhone.text! as String]
        
        refStores.child(key!).setValue(Stores)
        listStores()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
