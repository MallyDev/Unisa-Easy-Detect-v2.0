//
//  SecondViewController.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 07/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import UIKit
import CoreBluetooth
import UserNotifications

class PresenzaViewController: UIViewController,ESTBeaconManagerDelegate{
    
    //Variabili da salvare in maniera persistente (Aula,Aula Precedente, InAula, Ingresso)

    //Statica per accesso da AppDelegate
    static var aula:PAula? = nil
    
    var aulaPrecedente:PAula? = nil
    

    //Variabili

    var regionAula:CLBeaconRegion? = nil
    var dataStringIngresso:String = ""
    var regUnisa: CLBeaconRegion!
    var beaconManager:ESTBeaconManager?
    
    //Variabili utilizzate per conoscere lo stato del Bluetooth. Nel caso in cui questo risulti essere spento,verrà mostrato un alert.
    //var statoBluetooth:CBManagerState?
    //var myBTManager: CBPeripheralManager?
    
    //Variabile temporale per decidere se si è fuori dall'aula
    var seconds = 0
    var secondsCambioAula = 0
    var inAula:Bool = false
    
    @IBOutlet weak var presenzaInAulaLabel: UILabel!
    
    
    @IBOutlet weak var rilevazioneTitle: UILabel!
    @IBOutlet weak var orarioIngressoTitle: UILabel!
    @IBOutlet weak var ultimaPresenzaTitle: UILabel!
    
    @IBOutlet weak var orarioIngressoView: UIView!
    @IBOutlet weak var orarioIngressoLabel: UILabel!
    
    @IBOutlet weak var ultimaPresenzaView: UIView!
    @IBOutlet weak var ultimaPresenzaLabel: UILabel!
    
    @IBOutlet weak var inCorsoView: UIView!
    //@IBOutlet weak var inCorsoLabel: UILabel!
    // @IBOutlet weak var presenzaTableView: UITableView!
    
    @IBOutlet weak var presenzaButton: UIButton!
    @IBAction func completaPresenzaButton(_ sender: UIButton) {
        if(!UserDefaults.standard.bool(forKey: "inAula")){
            prendiPresenza()
        }else{
            completaPresenza()
        }
    }
    
    @IBAction func cancelPresenza(_ sender: UIBarButtonItem) {
        if(inAula){
                let alert3 = UIAlertController(title: "Attenzione", message: "Sei sicuro di voler cancellare la presenza in corso? In quest modo sarà salvato solo l'orario di ingresso.", preferredStyle: UIAlertControllerStyle.alert)
        
                let cancelAction = UIAlertAction(title: "No", style: .destructive,handler: nil)
                alert3.addAction(cancelAction)
            
        let cancellaPresenzaAction = UIAlertAction(title: "Si", style: .default,handler: {(alert: UIAlertAction!) in
           
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var uscita = formatter.date(from: UserDefaults.standard.string(forKey: "orarioIngresso")!)
            uscita = formatter.calendar.date(byAdding: .second, value: 1, to: uscita!)
            let uscitaStringa = formatter.string(from: uscita!)
            self.segnalaUscita(ingresso:UserDefaults.standard.string(forKey: "orarioIngresso")!,uscita: uscitaStringa)

        
        })
                 alert3.addAction(cancellaPresenzaAction)
                self.present(alert3, animated: true, completion: nil)
        }else{
            let alert2 = UIAlertController(title: "Attenzione", message: "Nessuna presenza in corso.", preferredStyle: UIAlertControllerStyle.alert)
            let cancel2 = UIAlertAction(title: "OK", style: .default,handler: nil)
            alert2.addAction(cancel2)
            self.present(alert2, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //myBTManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)

        // Do any additional setup after loading the view, typically from a nib.
        // let updateBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updatePresenza))
        
        //navigationItem.rightBarButtonItems = [updateBarButtonItem]
        
        self.rilevazioneTitle.layer.masksToBounds = true
        self.rilevazioneTitle.layer.cornerRadius = 4.0
        self.orarioIngressoTitle.layer.masksToBounds = true
        self.orarioIngressoTitle.layer.cornerRadius = 4.0
        self.ultimaPresenzaTitle.layer.masksToBounds = true
        self.ultimaPresenzaTitle.layer.cornerRadius = 4.0
        self.presenzaButton.layer.masksToBounds = true
        self.presenzaButton.layer.cornerRadius = 8.0
        
        ultimaPresenzaView.isHidden = true
        inCorsoView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(PresenzaViewController.restartTimer), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        
        OperationQueue.main.addOperation {
            
            self.beaconManager = ESTBeaconManager()
            //Definition of the object that implement the beacon manager's protocol
            self.beaconManager?.delegate = self
            
            //Definition of the region
            
            self.regUnisa = CLBeaconRegion(
                proximityUUID: UUID(uuidString: "36996E77-5789-6AA5-DF5E-25FB5D92B34B")!,identifier : "UNISA")
            
            //Request the permission to use location and notification
            self.beaconManager?.requestWhenInUseAuthorization()
            
            self.beaconManager?.startMonitoring(for: self.regUnisa)
            self.beaconManager?.startRangingBeacons(in: self.regUnisa)

        }
        

        NotificationCenter.default.addObserver(self, selector: #selector(PresenzaViewController.becomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        if (Utility.connectedToNetwork()){
            Utility.verificaAggiornamenti()
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //super.viewWillAppear(true)
        
        seconds = 0
        //aggiornaCorso()
        //turnOnBluetooth()
        
        /*
         VERIFICARE STATO PRESENZA
         */
        verificaStatoPresenza()
        presenzaButton.isHidden = true
        
        
        
    }
    
    //Verifica stato Bluetooth
   /*
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager){
    
        statoBluetooth = peripheral.state
        if peripheral.state == CBManagerState.poweredOn {
            print("Broadcasting...")
            //    myBTManager!.startAdvertising(_broadcastBeaconDict)
        } else if peripheral.state == CBManagerState.poweredOff {
            print("Stopped")
            turnOnBluetooth()
        } else if peripheral.state == CBManagerState.unsupported {
            print("Unsupported")
        } else if peripheral.state == CBManagerState.unauthorized {
            print("This option is not allowed by your application")
        }
    
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //richiamata ogni secondo quando l'app è attiva, ad intervalli indefiniti quando è in background (circa un minuto)
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //Non consideriamo i campioni con distanza non calcolata ( accurancy value < 0 )
        if (beacons.first != nil) {
            for beacon in beacons{
                if(beacon.accuracy < 0){
                    return
                }
            }
            
            
            let nearestAula = PersistenceManager.searchAulaBeacon(UUID: beacons.first!.proximityUUID.uuidString, major: Int32(CLBeaconMajorValue(beacons.first!.major)), minor: Int32(CLBeaconMinorValue(beacons.first!.minor)))
            seconds = 0
            if nearestAula != nil{
            
                presenzaButton.isHidden = false

                
            if(PresenzaViewController.aula == nil){
                
                if(!inAula){
                self.orarioIngressoLabel.text = ""
                
                OperationQueue.main.addOperation{
                    PresenzaViewController.aula = nearestAula
                    UserDefaults.standard.set(nearestAula?.codice!, forKey: "codiceAula")
                    self.presenzaInAulaLabel.text = "Sei in \((PresenzaViewController.aula!.nome)!)"
                    self.presenzaButton.isHidden = false
                    //self.prendiPresenza()
                    //self.aggiornaCorso()
                    self.inCorsoView.isHidden = false
                 
                    }
                }else if(inAula){
                    self.inCorsoView.isHidden = false

                }

                
            }else if(PresenzaViewController.aula!.codice != nearestAula!.codice){
                //cambio aula
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                var uscita = formatter.date(from: dataStringIngresso)
                uscita = formatter.calendar.date(byAdding: .second, value: 1, to: uscita!)
                let uscitaStringa = formatter.string(from: uscita!)
                segnalaUscita(ingresso:dataStringIngresso,uscita: uscitaStringa)
                
                self.orarioIngressoLabel.text = ""
                
                     OperationQueue.main.addOperation {
                        
                        
                        
                        self.aulaPrecedente = PresenzaViewController.aula
                        
                        UserDefaults.standard.set( self.aulaPrecedente!.codice!, forKey: "codiceAulaPrecedente")
                        
                        //self.completaPresenza()
                        
                        
                        PresenzaViewController.aula = nearestAula
                        UserDefaults.standard.set( nearestAula!.codice!, forKey: "codiceAula")

                 
                        self.presenzaButton.isHidden = false
                        
                        self.presenzaInAulaLabel.text = "Sei in \((PresenzaViewController.aula!.nome)!)"
                        
                        //self.aggiornaCorso()
                        
                       self.secondsCambioAula = 0

                    }
                    
                
            }else{
                if(inAula){
                    self.inCorsoView.isHidden = false
                }
            }
                
            
            }//fine nerarestAula != nil
         //fine beacons.first != nil
        }else{
            if(!inAula){
                if(seconds >= 5){
                
                OperationQueue.main.addOperation {
                    // Update UI
                self.presenzaInAulaLabel.text = "Nessuna aula rilevata"
                self.orarioIngressoLabel.text = ""
                //self.inCorsoLabel.text = ""
                self.seconds=0
                PresenzaViewController.aula = nil
                UserDefaults.standard.set(nil, forKey: "codiceAula")

                self.inCorsoView.isHidden = true

                }
                
            }else{
                OperationQueue.main.addOperation{
                    self.seconds+=1
                    
                    }
            }
            
            }else{
                 self.aulaPrecedente = PresenzaViewController.aula
                UserDefaults.standard.set(self.aulaPrecedente!.codice!, forKey: "codiceAulaPrecedente")

                inCorsoView.isHidden = true
                 inAula = true
                UserDefaults.standard.set(true, forKey: "inAula")

            }
    }
    
}
    
    private func prendiPresenza(){
        //prendi nuova presenza
        
        let timestamp = Date.init()
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "Europe/Rome")! as TimeZone
        dataStringIngresso = dateFormatter.string(from: timestamp)
        aggiungiPresenza(ingresso: dataStringIngresso)
    }
    
    private func completaPresenza(){
        let timestamp = Date.init()
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "Europe/Rome")! as TimeZone
        let dataStringUscita = dateFormatter.string(from: timestamp)
        segnalaUscita(ingresso:dataStringIngresso,uscita: dataStringUscita)
    }
    
    
    private func aggiungiPresenza(ingresso: String)
    {
        let VW_overlay = UIView(frame: UIScreen.main.bounds)
        VW_overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: activityIndicatorView.bounds.size.width, height: activityIndicatorView.bounds.size.height)
        
        activityIndicatorView.center = VW_overlay.center
        VW_overlay.addSubview(activityIndicatorView)
        VW_overlay.center = self.view.center
        self.view.addSubview(VW_overlay)
        
        activityIndicatorView.startAnimating()
      

        let urlReg = "http://193.205.163.43/beaconDetector/src/public/presenza"
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        
        let codiceAula = PresenzaViewController.aula!.codice
        
        let jsonUpload = [
            "UUID" : uuid!,
            "aula" : codiceAula!,
            "ingresso":ingresso] as [String:Any]
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
                    sleep(1)
                    activityIndicatorView.stopAnimating()
                    VW_overlay.isHidden = true
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200{
                        OperationQueue.main.addOperation{
                            /*
                            // create an NSMutableAttributedString that we'll append everything to
                            let startString = ""
                            let endString = "Sei in aula \((self.aula!.nome)!)"
                            let fullString = NSMutableAttributedString(string: startString)
                            
                            // create our NSTextAttachment
                            let imageCheckPresenza = NSTextAttachment()
                            imageCheckPresenza.image = UIImage(named: "CheckPresenza")
                            // wrap the attachment in its own attributed string so we can append it
                            let imageCheckString = NSAttributedString(attachment: imageCheckPresenza)
                            
                            // add the NSTextAttachment wrapper to our full string, then add some more text.
                            fullString.append(imageCheckString)
                            fullString.append(NSAttributedString(string: endString))
 
                            // draw the result in a label
                            self.presenzaInAulaLabel.attributedText = fullString
                             */
                            self.orarioIngressoView.isHidden = false
                            
                            self.orarioIngressoLabel.text = "\(ingresso)"
                            UserDefaults.standard.set(ingresso, forKey: "orarioIngresso")

                            
                           // self.creaPromemoria()
                            
                            self.inAula = true
                            UserDefaults.standard.set(true, forKey: "inAula")

                            self.inCorsoView.isHidden = false
                            
                            self.presenzaButton.setTitle("SEGNALA USCITA", for: .normal)
                            sleep(1)
                            activityIndicatorView.stopAnimating()
                            VW_overlay.isHidden = true
                        }
                        
                    }else{
                         OperationQueue.main.addOperation {
                            // Update UI
                        self.orarioIngressoLabel.text = "Presenza non registrata. Riprovare."
                            print("BACKGROUND : PRESENZA NON REGISTRATA")
                            sleep(1)
                            activityIndicatorView.stopAnimating()
                            VW_overlay.isHidden = true
                        }
                        
                    }
                }
            }
            task.resume()
        }
    }
    

    private func segnalaUscita(ingresso:String,uscita: String)
    {
        
        let VW_overlay = UIView(frame: UIScreen.main.bounds)
        VW_overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: activityIndicatorView.bounds.size.width, height: activityIndicatorView.bounds.size.height)
        
        activityIndicatorView.center = VW_overlay.center
        VW_overlay.addSubview(activityIndicatorView)
        VW_overlay.center = self.view.center
        self.view.addSubview(VW_overlay)
        
        activityIndicatorView.startAnimating()
        
        
        let urlReg = "http://193.205.163.43/beaconDetector/src/public/presenza/uscita"
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        
        let codiceAula = PresenzaViewController.aula?.codice!
        
        let jsonUpload = [
            "UUID" : uuid!,
            "aula" : codiceAula!,
            "ingresso": ingresso,
            "uscita": uscita] as [String:Any]
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
                    activityIndicatorView.stopAnimating()
                    VW_overlay.isHidden = true
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200{
                         OperationQueue.main.addOperation {
                            // Update UI
                           
                            
                            let ultimaPresenzaString = "\((PresenzaViewController.aula!.nome!)) \n Ingresso: \(ingresso) \n Uscita: \(uscita)"
                            self.ultimaPresenzaView.isHidden = false
                            self.ultimaPresenzaLabel.text = ultimaPresenzaString
                            print("BACKGROUND : PRESENZA CHIUSA")
                            self.inAula = false
                            UserDefaults.standard.set(false, forKey: "inAula")
                            //self.inCorsoView.isHidden = true
                            self.orarioIngressoLabel.text = ""
                            UserDefaults.standard.set(nil, forKey: "orarioIngresso")
                            self.presenzaButton.setTitle("SEGNALA INGRESSO", for: .normal)
                            sleep(1)
                            activityIndicatorView.stopAnimating()
                            VW_overlay.isHidden = true
                        }
                        
                    }else{
                         OperationQueue.main.addOperation {
                            // Update UI
                            self.ultimaPresenzaView.isHidden = false
                            self.ultimaPresenzaLabel.text = "Uscita non registrata. Impossibile contattare il server. Riprovare."
                            print("BACKGROUND : PRESENZA NON CHIUSA")
                            sleep(1)
                            activityIndicatorView.stopAnimating()
                            VW_overlay.isHidden = true
                        }
                        
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func restartTimer(notification: NSNotification){
        seconds = 0
    }
    
    /*func turnOnBluetooth(){
    //bluetooth spento
        if (self.statoBluetooth?.rawValue == CBManagerState.poweredOff.rawValue){
                let alert = UIAlertController(title: "Attenzione", message: "Accendere il bluetooth per utilizzare correttamente l'applicazione.", preferredStyle: UIAlertControllerStyle.alert)
                let settingsAction = UIAlertAction(title: "Impostazioni", style: .default) { (_) -> Void in
                    
                    UIApplication.shared.open(URL(string:"App-Prefs:root=Bluetooth")!, options: [:], completionHandler: nil)
                }
                alert.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Chiudi", style: .destructive,handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }

            
     }*/
    
    private func verificaStatoPresenza(){
        if UserDefaults.standard.string(forKey: "codiceAula") != nil{
            if (UserDefaults.standard.bool(forKey: "inAula")){
                if UserDefaults.standard.string(forKey: "orarioIngresso") != nil{
                    print("ORARIOINGRESSO")
                    self.orarioIngressoLabel.text = UserDefaults.standard.string(forKey: "orarioIngresso")!
                    orarioIngressoView.isHidden = false
                    self.inAula = true
                    PresenzaViewController.aula = PersistenceManager.searchAula(codiceAula: UserDefaults.standard.string(forKey: "codiceAula")!)
                    dataStringIngresso = UserDefaults.standard.string(forKey: "orarioIngresso")!
                    self.presenzaInAulaLabel.text = "Sei in \((PresenzaViewController.aula!.nome)!)"
                }else{
                    orarioIngressoView.isHidden = true
                }
                
            }
            
        }
        if let aulaPrecedente = UserDefaults.standard.string(forKey: "codiceAulaPrecedente"){
            self.aulaPrecedente = PersistenceManager.searchAula(codiceAula: aulaPrecedente)
        }
        //TITOLO BOTTONE SEGNALA INGRESSO/USCITA
        OperationQueue.main.addOperation {
            if(!UserDefaults.standard.bool(forKey: "inAula")){
                self.presenzaButton.setTitle("SEGNALA INGRESSO", for: .normal)
            }else{
                self.presenzaButton.setTitle("SEGNALA USCITA", for: .normal)
            }
        }
        
    }
    
    func becomeActive(){
        //turnOnBluetooth()
        presenzaButton.isHidden = true

        verificaStatoPresenza()
    }
    
    /*
     func aggiornaCorso(){
        if(PresenzaViewController.aula != nil){
            let nomeAula = "\(PresenzaViewController.aula!.nome!)_\(PresenzaViewController.aula!.codice!)"
            let id = Utility.creazioneOrario()
            if (id != ""){
                var url = "http://193.205.163.43/beaconDetector/src/public/orario/\(nomeAula)/\(id)"
                url = url.replacingOccurrences(of: " ", with: "")
                
                
                //download orario
                let destOrario = URL(string: url)
                URLSession.shared.dataTask(with: destOrario!, completionHandler:{ (data,response,error) in
                    if error != nil {
                        print("Errore nella sessione: \(String(describing: error))")
                    }else{
                        if let dataVar = data {
                            let returnData = String(data: dataVar, encoding: .utf8)
                            if(returnData! != "\nAula Libera" || returnData! != "\n"){
                                OperationQueue.main.addOperation{
                                    self.inCorsoLabel.text = returnData!
                                }
                                
                            }
                        }
                    }
                }).resume()
            }
            
        }
    }
    
    */

   @IBAction func chooseSegue(_ sender: Any) {
        if(PersistenceManager.fetchUtente() != nil){
            self.performSegue(withIdentifier: "showProfile", sender: nil)
        }else{
            self.performSegue(withIdentifier: "showFirstProfile", sender: nil)
        }
    }
 
}


