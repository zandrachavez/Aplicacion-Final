//
//  ViewController.swift
//  MyNailsApp
//
//  Created by mac on 09/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var refNails: DatabaseReference!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtHour: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tblNails: UITableView!
    
    //@IBOutlet weak var textFielInstrument: UITextField!
    //@IBOutlet weak var textFieldPrice: UITextField!
    //@IBOutlet weak var labelMessage: UILabel!
    
    //@IBOutlet weak var tblInstruments: UITableView!
    
    var NailsList = [NailModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Nail = NailsList[indexPath.row]
        print(Nail.id!)
        let alertController = UIAlertController(title:Nail.Nail, message:"Give me values to update Date", preferredStyle:.alert)
        
        let updateAction =  UIAlertAction(title: "Update", style:.default){(_) in
            
            //Checar el Id que no almacena los datos
            let id = Nail.id
            
            let Nail = alertController.textFields?[0].text
            let Hour = alertController.textFields?[1].text
            
            self.updateNail(id: id!, Nail: Nail!, Hour: Hour!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style:.default){(_) in
            self.deleteNail(id: Nail.id!)
        }
        
        alertController.addTextField{(textField) in textField.text = Nail.Nail
            
        }
        
        alertController.addTextField{(textField) in textField.text = Nail.Hour
            
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
    }
    
    func updateNail(id: String, Nail: String, Hour: String){
        let Nail = ["id": id, "NailName": Nail, "NailHour": Hour]
        
        refNails.child(id).setValue(Nail)
        labelMessage.text = "Date Updated"
        listNails()
    }
    
    func deleteNail(id:String){
        refNails.child(id).setValue(nil)
        listNails()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NailsList.count
    }
    
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let Nails: NailModel
        
        Nails = NailsList[indexPath.row]
        
        cell.lblName.text = Nails.Nail
        cell.lblHour.text = Nails.Hour
        
        return cell
    }
    
    //@IBAction func ButtonAddPiano(_ sender: UIButton) {
        
        //@IBAction func ButtonAddInstrument(_ sender: UIButton) {
    @IBAction func ButtonAddDate(_ sender: UIButton) {
        
        addDate()
        txtName.text = "";
        txtHour.text = "";
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Use Firebase library to configure APIs
        if FirebaseApp.app() == nil{
        FirebaseApp.configure()
        }
        refNails = Database.database().reference().child("Nail");
        listNails()
    }
    func listNails(){
        refNails.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>=0{
                self.NailsList.removeAll()
                
                for Nails in snapshot.children.allObjects as![DataSnapshot]{
                    let NailObject = Nails.value as? [String: AnyObject]
                    let NailName = NailObject?["NailName"]
                    let NailHour = NailObject?["NailHour"]
                    let NailId = NailObject?["id"]
                    
                    let Nail = NailModel(id: NailId as! String?, Nail: NailName as! String?, Hour: NailHour as! String?)
                    self.NailsList.append(Nail)
                }
                
                self.tblNails.reloadData()
            }
        })
        
        
    }
    
    func addDate(){
        let key = refNails.childByAutoId().key
        
        let Nails = ["id":key,"NailName": txtName.text! as String,"NailHour": txtHour.text! as String]
        
        refNails.child(key!).setValue(Nails)
        listNails()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
