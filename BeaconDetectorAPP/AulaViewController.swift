//
//  AulaViewController.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 07/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import UIKit
import MapKit

class AulaViewController: UIViewController {
    
    var aulaCorrente: PAula? = nil
    var urlOrario:String?
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var capienzaLabel: UILabel!
    @IBOutlet weak var descrizioneLabel: UILabel!
    @IBOutlet weak var dettagliLabel: UILabel!
    @IBOutlet weak var CDLLabel: UILabel!
    
    @IBOutlet weak var locationTitleView: UILabel!
    @IBOutlet weak var capienzaTitleView: UILabel!
    @IBOutlet weak var descrizioneTitleView: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let regionRadius: CLLocationDistance = 200
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let id = Utility.creazioneOrario()
        
        //if(id != ""){
        let urlOccupazione = "http://193.205.163.43/beaconDetector/src/public/occupazione/\(aulaCorrente!.codice!)"

        //verifica occupazione
        let destOccupazione = URL(string: urlOccupazione)
        if destOccupazione != nil{
            URLSession.shared.dataTask(with: destOccupazione!, completionHandler:{ (data,response,error) in
                if error != nil {
                    print("Errore nella sessione: \(String(describing: error))")

                }else{
                    if let dataVar = data {
                        let returnData = String(data: dataVar, encoding: .utf8)
                        print("Numero studenti presenti: \(returnData!)")
                        if(returnData! != "\n"){

                            OperationQueue.main.addOperation{
                                let occupazione = Int(returnData!.replacingOccurrences(of: "\n", with: ""))
                                self.capienzaLabel.text = "\(occupazione!) / \(self.aulaCorrente!.capienza)"
                                
                                let progressNum =  (Float(occupazione!) / Float(self.aulaCorrente!.capienza))
                                
                                print("Progresso ProgressBar : \(progressNum)")
                                self.progressBar.isHidden = false
                                
                                self.progressBar.setProgress(Float(progressNum),animated: true)
                                self.capienzaTitleView.text = "Occupazione"
                            }
                            
                        }
                    }
                }
            }).resume()
        }
    //}

    
        let nomeAula = "\(aulaCorrente!.nome!)_\(aulaCorrente!.codice!)"
        
        if (id != ""){
            var url = "http://193.205.163.43/beaconDetector/src/public/orario/\(nomeAula)/\(id)"
            url = url.replacingOccurrences(of: " ", with: "")
            //download orario
        let destOrario = URL(string: url)
            if destOrario != nil{
        URLSession.shared.dataTask(with: destOrario!, completionHandler:{ (data,response,error) in
            if error != nil {
                print("Errore nella sessione: \(String(describing: error))")
            }else{
                if let dataVar = data {
                    let returnData = String(data: dataVar, encoding: .utf8)
                    if(returnData! != "\n"){
                        OperationQueue.main.addOperation{
                            self.descrizioneTitleView.text = "In Corso"
                            let inCorso = returnData!.replacingOccurrences(of: "\n", with: "")
                            self.descrizioneLabel.text = "\(inCorso)"
                        }
                    }
                }
            }
        }).resume()
            }
       }
        
        let utente = PersistenceManager.fetchUtente();
        if(utente == nil){
            self.dettagliLabel.isHidden = true
            self.CDLLabel.isHidden = true
        }else{
            // impostare dettagli
            let matricola = utente?.matr
            let search = matricola!.prefix(5)
            let url2 = "http://193.205.163.43/beaconDetector/src/public/ricercaPresenti/\(String(describing: search))"
            print(url2)
            
            guard let urlSearch = URL(string: url2) else { return }
            
                URLSession.shared.dataTask(with: urlSearch, completionHandler:{ (data,response,error) in
                    if error != nil {
                        print("Errore nella sessione: \(String(describing: error))")
                        
                    }else{
                        if let dataS = data {
                            let returnData2 = String(data: dataS, encoding: .utf8)
                            print("Studenti stesso CDL: \(returnData2!)")
                            if(returnData2! != "\n"){
                                OperationQueue.main.addOperation{
                                    let dettagli = returnData2!.replacingOccurrences(of: "\n", with: "")
                                    if(dettagli == "1"){
                                        self.dettagliLabel.text = "È presente "+dettagli+" studente di "
                                    }else{
                                        self.dettagliLabel.text = "Sono presenti "+dettagli+" studenti di "
                                    }
                                    self.CDLLabel.text = (utente?.cdl)!
                                }
                            }else{
                                OperationQueue.main.addOperation{
                                    self.dettagliLabel.isHidden = true
                                    self.CDLLabel.isHidden = true
                                }
                            }
                        }
                    }
                }).resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.capienzaTitleView.layer.masksToBounds = true
        self.capienzaTitleView.layer.cornerRadius = 4.0
        self.locationTitleView.layer.masksToBounds = true
        self.locationTitleView.layer.cornerRadius = 4.0
        self.descrizioneTitleView.layer.masksToBounds = true
        self.descrizioneTitleView.layer.cornerRadius = 4.0
        mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
        
        
        let boldTextEdificio  = "Edificio: "
        let attrsEdificio = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
        let attributedStringEdificio = NSMutableAttributedString(string:boldTextEdificio, attributes:attrsEdificio)
        
        let normalTextEdificio = "\(String(describing: (aulaCorrente!.edificio)!))"
        let normalStringEdificio = NSMutableAttributedString(string:normalTextEdificio)
        
        attributedStringEdificio.append(normalStringEdificio)
        
        let boldTextPiano  = "   Piano: "
        let attrsPiano = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
        let attributedStringPiano = NSMutableAttributedString(string:boldTextPiano, attributes:attrsPiano)

        let normalTextPiano = "\(String(describing: (aulaCorrente!.piano)))"
        let normalStringPiano = NSMutableAttributedString(string:normalTextPiano)
        
        attributedStringPiano.append(normalStringPiano)
        
        let location = NSMutableAttributedString()
        location.append(attributedStringEdificio)
        location.append(attributedStringPiano)
        
        self.locationLabel.attributedText = location
 
        //self.locationLabel.text = "Edificio: \(aulaCorrente!.edificio!) Piano: \(aulaCorrente!.piano)"
        let capienza = aulaCorrente?.capienza
        if (capienza! > 0){

            self.capienzaLabel.text = "\(aulaCorrente!.capienza) posti"

  
        }else{
        self.capienzaLabel.isHidden = true
        }
        
        let descrizione = aulaCorrente?.descrizione
        if (descrizione! != ""){
            self.descrizioneLabel.text = "\(String(describing: descrizione!))"
        }else{
            self.descrizioneLabel.text = ""
        }
        // set initial location in Unisa
        let initialLocation = CLLocation(latitude: 40.772815, longitude: 14.7900975)
        centerMapOnLocation(location: initialLocation)
        
        let annotations = getMapAnnotation()
        // Add mappoints to Map
        mapView.addAnnotations(annotations)
        
        
        let btn1 = UIButton(type: .custom)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.setImage(UIImage(named: "calendar"), for: .normal)
        btn1.addTarget(self, action: #selector(mostraOrari), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Add annotation to Map
    
    //MARK:- Annotations
    
    func getMapAnnotation() -> [AulaMapAnnotation] {
        
    var annotation:Array = [AulaMapAnnotation]()
        
    
    //create Annotation
    let lat = aulaCorrente?.lat
    let long = aulaCorrente?.long
    annotation.append(AulaMapAnnotation(latitude: lat!, longitude: long!))
    annotation[0].title = self.aulaCorrente?.nome
    
    
    return annotation
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func startNavigatore(_ sender: UIButton) {
        
        let latitude: CLLocationDegrees = aulaCorrente!.lat
        let longitude: CLLocationDegrees = aulaCorrente!.long
        
        let regionDistance:CLLocationDistance = 500
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(String(describing: aulaCorrente!.nome!)) - \(locationLabel.text!)"
        mapItem.openInMaps(launchOptions: options)
        
    }
    func mostraOrari(){
        self.performSegue(withIdentifier: "segueToOrarioAulaViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToOrarioAulaViewController" {
            if let destination = segue.destination as? OrarioAulaViewController {
                
                 destination.url = "http://193.205.163.43/beaconDetector/src/public/orario/\(aulaCorrente!.nome!)_\(aulaCorrente!.codice!)".replacingOccurrences(of: " ", with: "")
                destination.title = "Orario"
            }
        }
    }
}
