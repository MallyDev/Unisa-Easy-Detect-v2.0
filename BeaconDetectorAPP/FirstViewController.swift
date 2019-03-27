//
//  FirstViewController.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 21/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    var semaforo = false
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //PRE: Connessione a internet
        //Registrazione dell'utente se non l'ha ancora fatto altrimenti aggiornemento DB
        if(Utility.connectedToNetwork()){
            if(!UserDefaults.standard.bool(forKey: "registrazioneDevice")){
                registerUser()
            }else if(UserDefaults.standard.bool(forKey: "registrazioneDevice") && UserDefaults.standard.double(forKey: "versioneDB") == 0.0){
                PersistenceManager.deleteAll()
                DataBaseManager.databaseDownload()
                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.indicator.stopAnimating()
                    self.performSegue(withIdentifier: "showFirstView", sender: nil)
                    // Your code with delay
                }
                
            }
        }
        
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //Carica l'id dell'utente appena apre l'applicazione
    private func registerUser()
    {
        let urlReg = "http://193.205.163.43/beaconDetector/src/public/dispositivo/associazione"
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        
        let jsonUpload = [
            "UUID" : uuid!
            ] as [String:Any]
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonUpload, options: .prettyPrinted){
            let url = NSURL(string: urlReg)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print("Errore nella registrazione dell'id dell'utente. \(String(describing: error))")
                    
                }
                if let httpResponse = response as? HTTPURLResponse {
                    
                    
                    if httpResponse.statusCode == 200{
                        
                        PersistenceManager.deleteAll()
                        DataBaseManager.databaseDownload()
                        
                        let when = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self.indicator.stopAnimating()
                            self.performSegue(withIdentifier: "showFirstView", sender: nil)
                            // Your code with delay
                        }
                    }else{
                        UserDefaults.standard.set(false, forKey: "registrazioneDevice")
                        let alert = UIAlertController(title: "Errore del Server", message: "Riprovare più tardi.", preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction = UIAlertAction(title: "Chiudi", style: .destructive,handler: nil)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                        PersistenceManager.deleteAll()
                        
                        
                    }
                    
                    
                }
                
            }
            task.resume()
        }
    }
    
    
    func downloadDatabaseView(){
        //PRE: Connessione a internet
        //Registrazione dell'utente se non l'ha ancora fatto altrimenti aggiornamento DB
        if(Utility.connectedToNetwork()){
            if(!UserDefaults.standard.bool(forKey: "registrazioneDevice")){
                registerUser()
            }else if(UserDefaults.standard.bool(forKey: "registrazioneDevice") && UserDefaults.standard.double(forKey: "versioneDB") == 0.0){
                PersistenceManager.deleteAll()
                DataBaseManager.databaseDownload()
                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.indicator.stopAnimating()
                    self.performSegue(withIdentifier: "showFirstView", sender: nil)
                    // Your code with delay
                }

            }
        }
    }
}
