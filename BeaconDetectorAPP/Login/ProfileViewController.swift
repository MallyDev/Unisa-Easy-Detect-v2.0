//
//  ProfileViewController.swift
//  BeaconDetectorAPP
//
//  Created by Maria Laura Bisogno.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate{
    var info = [String:String]()
    var firstTime = false
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var cdlLabel: UILabel!
    @IBOutlet weak var annoLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var annoText: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lastSeparator: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //aggiunta dei listener per quando la tastiera viene mostrata o nascosta
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyBoard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyBoard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let context = PersistenceManager.getContext()
        let name = info["givenName"]?.capitalized
        let surname = info["surname"]?.capitalized
        let matr = info["employeeNumbere"]
        let cdl = info["studenteCorsoDiLaurea"]?.capitalized
        
        
        //salvataggio delle informazioni Core Data e modifica delle label
        if(PersistenceManager.fetchUtente() == nil){
            context.perform {
                let utente = PersistenceManager.newEmptyUtente(context: context)
                utente.nome = name
                utente.matr = matr
                utente.cdl = cdl
                
                //controllo se l'informazione riguardo l'anno di iscrizione è presente nel database
                let url = "http://193.205.163.43/beaconDetector/src/public/ricercaAnno/\(String(describing: matr!))"
                print(url)
                
                let urlSearch = URL(string: url)
                
                URLSession.shared.dataTask(with: urlSearch!, completionHandler:{ (data,response,error) in
                    if error != nil {
                        print("Errore nella sessione: \(String(describing: error))")
                        
                    }else{
                        if let dataS = data {
                            let returnData2 = String(data: dataS, encoding: .utf8)
                            print("Anno iscrizione: \(returnData2!)")
                            if(returnData2! != "\n"){
                                OperationQueue.main.addOperation{
                                    let anno = returnData2!.replacingOccurrences(of: "\n", with: "")
                                    utente.anno = anno
                                    self.annoLabel.text = anno
                                }
                            }else{
                                utente.anno = self.annoLabel.text
                            }
                        }
                    }
                        do{
                            try context.save()
                        }catch{
                            fatalError("Failure to save context: \(error)" )
                        }
                    
                }).resume()
                
            }
            
            welcomeLabel.text = name!
            numLabel.text = matr
            cdlLabel.text = cdl
            
            //gestione DB
            uploadStudent(matr: matr!, name: name!, surname: surname!, cdl: cdl!)
            
        }else{
            let utente = PersistenceManager.fetchUtente()
            welcomeLabel.text = utente?.nome
            numLabel.text = utente?.matr
            cdlLabel.text = utente?.cdl
            annoLabel.text = utente?.anno
        }
        
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        annoLabel.isHidden = true
        editButton.isHidden = true
        lastSeparator.isHidden = true
        annoText.isHidden = false
        okButton.isHidden = false
        
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        let context = PersistenceManager.getContext()
        
        if(annoText.hasText){
            annoLabel.text = annoText.text
            context.perform {
                let utente = PersistenceManager.fetchUtente()
                utente?.anno = self.annoText.text
                
                do{
                    try context.save()
                }catch{
                    fatalError("Failure to save context: \(error)" )
                }
            }
            
            //gestione DB
            let utente = PersistenceManager.fetchUtente()
            let anno = annoText.text!
            let matricola = utente?.matr
            
            let urlAnno = "http://193.205.163.43/beaconDetector/src/public/aggiornaAnno"
            let jsonUpload = [
                "matricola" : matricola!,
                "anno" : anno
                ] as [String:Any]
            
            print("\n\n Anno utente: ")
            print(jsonUpload)
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonUpload, options: .prettyPrinted){
                let url = NSURL(string: urlAnno)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                    if error != nil{
                        print("ERRORE nel salvataggio dell'anno di iscrizione. \(String(describing: error))")
                    }
                }
                task.resume()
            }
        }
        annoText.isHidden = true
        okButton.isHidden = true
        annoLabel.isHidden = false
        editButton.isHidden = false
        lastSeparator.isHidden = false
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    //funzione che (insieme con handleHideKeyBoard) permette di gestire lo scroll della view per non nascondere i contenuti
    func handleShowKeyBoard(_ notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        scrollView.contentInset.bottom = keyboardSize
    }
    
    func handleHideKeyBoard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0
    }
    
    //il logout cancella i coredata riguardanti l'utente e rimuove l'associazione tra l'utente e i suoi dispositivi presente nel database. In questo modo la presenza dell'utente sarà anonima.
    @IBAction func logout(_ sender: Any) {
        PersistenceManager.deleteUtente()
        navigationController?.viewControllers.removeLast()
        //gestione DB
        let urlUtente = "http://193.205.163.43/beaconDetector/src/public/cancUtente"
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let jsonUpload = [
            "UUID" : uuid!
            ] as [String:Any]
        
        print("\n\n Dispositivo utente: ")
        print(jsonUpload)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonUpload, options: .prettyPrinted){
            let url = NSURL(string: urlUtente)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print("ERRORE nella cancellazione dell'utente. \(String(describing: error))")
                }
            }
            task.resume()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (firstTime){
            navigationController?.viewControllers.removeLast()
        }
    }
    
    //funzione per gestire la registrazione dello studente nel db
    func uploadStudent(matr: String, name: String, surname: String, cdl: String){
        let urlStudente = "http://193.205.163.43/beaconDetector/src/public/studente"
        let jsonUpload = [
            "matricola" : matr,
            "nome" : name,
            "cognome" : surname,
            "cdl" : cdl,
            "anno" : "Inserisci l'anno di iscrizione"
        ] as [String:Any]
        
        print("\n\n Info Studente: ")
        print(jsonUpload)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonUpload, options: .prettyPrinted){
            let url = NSURL(string: urlStudente)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print("ERRORE nella registrazione dello studente. \(String(describing: error))")
                }
            }
            task.resume()
        }
        
        let urlUtente = "http://193.205.163.43/beaconDetector/src/public/utente"
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let jsonUpload2 = [
            "matricola" : matr,
            "UUID" : uuid!
            ] as [String:Any]
        
        print("\n\n Info Utente: ")
        print(jsonUpload2)
        
        if let jsonData2 = try? JSONSerialization.data(withJSONObject: jsonUpload2, options: .prettyPrinted){
            let url = NSURL(string: urlUtente)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData2
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print("ERRORE nella registrazione dello studente. \(String(describing: error))")
                }
            }
            task.resume()
        }
    }
    
}
