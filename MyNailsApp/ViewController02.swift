//
//  ViewController02.swift
//  MyNailsApp
//
//  Created by mac on 09/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController02: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var refProducts: DatabaseReference!
    
    @IBOutlet weak var txtProduct: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tblProducts: UITableView!
    
    
    
    
    
    var ProductsList = [ProductModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Product = ProductsList[indexPath.row]
        print(Product.id!)
        let alertController = UIAlertController(title:Product.Product, message:"Give me values to update Date", preferredStyle:.alert)
        
        let updateAction =  UIAlertAction(title: "Update", style:.default){(_) in
            
            //Checar el Id que no almacena los datos
            let id = Product.id
            
            let Product = alertController.textFields?[0].text
            let Price = alertController.textFields?[1].text
            
            self.updateProduct(id: id!, Product: Product!, Price: Price!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style:.default){(_) in
            self.deleteProduct(id: Product.id!)
        }
        
        alertController.addTextField{(textField) in textField.text = Product.Product
            
        }
        
        alertController.addTextField{(textField) in textField.text = Product.Price
            
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
    }
    
    func updateProduct(id: String, Product: String, Price: String){
        let Product = ["id": id, "ProductName": Product, "ProductPrice": Price]
        
        refProducts.child(id).setValue(Product)
        labelMessage.text = "Product Updated"
        listProducts()
    }
    
    func deleteProduct(id:String){
        refProducts.child(id).setValue(nil)
        listProducts()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductsList.count
    }
    
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableViewCell02
        
        let Products: ProductModel
        
        Products = ProductsList[indexPath.row]
        
        cell.tblProduct.text = Products.Product
        cell.tblPrice.text = Products.Price
        
        return cell
    }
    
    //@IBAction func ButtonAddPiano(_ sender: UIButton) {
    
    //@IBAction func ButtonAddInstrument(_ sender: UIButton) {
   
    
    @IBAction func ButtonAddProduct(_ sender: UIButton) {
       
    
        addProduct()
        txtProduct.text = "";
        txtPrice.text = "";
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Use Firebase library to configure APIs
        if FirebaseApp.app() == nil{
            FirebaseApp.configure()
        }
        
        refProducts = Database.database().reference().child("Product");
        listProducts()
    }
    func listProducts(){
        refProducts.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>=0{
                self.ProductsList.removeAll()
                
                for Products in snapshot.children.allObjects as![DataSnapshot]{
                    let ProductObject = Products.value as? [String: AnyObject]
                    let ProductName = ProductObject?["ProductName"]
                    let ProductPrice = ProductObject?["ProductPrice"]
                    let ProductId = ProductObject?["id"]
                    
                    let Product = ProductModel(id: ProductId as! String?, Product: ProductName as! String?, Price: ProductPrice as! String?)
                    self.ProductsList.append(Product)
                }
                
                self.tblProducts.reloadData()
            }
        })
        
        
    }
    
    func addProduct(){
        let key = refProducts.childByAutoId().key
        
        let Products = ["id":key,"ProductName": txtProduct.text! as String,"ProductPrice": txtPrice.text! as String]
        
        refProducts.child(key!).setValue(Products)
        listProducts()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
