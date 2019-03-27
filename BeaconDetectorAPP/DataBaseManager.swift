//
//  DataBaseManager.swift
//  beaconDetector
//
//  Created by Mario Cantalupo on 06/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataBaseManager{
   
    static func databaseDownload()
    {
        
        let myGroup = DispatchGroup()
        var versioneDBvar:Double?
        
        for _ in 0..<5{
            myGroup.enter()
        }
        
        //versione DB
        
        let urlString = "http://193.205.163.43/beaconDetector/src/public/versioneDB"
        let urlDB = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: urlDB as URL)
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if error != nil{
                print("Errore nella registrazione dell'id dell'utente. \(String(describing: error))")
                
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200{
                    if let dataVar = data {
                        let string = String(data: dataVar, encoding: .utf8)!
                        let versioneDBString = string.replacingOccurrences(of: "\n", with: "")
                        var versioneDB = Double(versioneDBString)
                        let versioneCorrente = UserDefaults.standard.double(forKey: "versioneDB")
                        if( versioneDB! > versioneCorrente){
                            print(UserDefaults.standard.double(forKey: "versioneDB"))
                            versioneDBvar = versioneDB!
                        }
                    }
                    print("Finished request versione DB")
                    myGroup.leave()
                }
            }
            
        }
        task.resume()
        
        
        
        let url = "http://193.205.163.43/beaconDetector/src/public/"
        
        //download Aule
        let destAule = URL(string: url+"aule")
        URLSession.shared.dataTask(with: destAule!, completionHandler:{ (data,response,error) in
            if error != nil {
                print("Errore nella sessione: \(String(describing: error))")
            }else{
                
                do{
                    let jsonAule = try JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
                    
                    let moc = PersistenceManager.getContext()
                    let privateMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    privateMoc.parent = moc
                    
                    privateMoc.perform {
                        for aula in jsonAule{
                            
                            
                            let temp=PersistenceManager.newEmptyAula(context: privateMoc)
                            
                            temp.codice = aula["CODICEAULA"] as! String?
                            temp.edificio = aula["NOMEEDIFICIO"] as! String?
                            temp.piano = Int16(aula["NUMEROPIANO"] as! String)!
                            temp.nome = aula["NOMEAULA"] as! String?
                            
                            if let descrizione = aula["DESCRIZIONEAULA"] as? String{
                                temp.descrizione = descrizione
                            }
                            if let capienza = aula["CAPIENZAAULA"] as? String{
                                let capienzaInt:Int16 = Int16(capienza)!
                                temp.capienza = capienzaInt
                            }
                            
                            
                            temp.lat = Double(aula["LATAULA"] as! String)!
                            temp.long = Double(aula["LONGAULA"] as! String)!
                            
                            
                        }
                        
                        do{
                            try privateMoc.save()
                            moc.performAndWait {
                                do {
                                    try moc.save()
                                } catch{
                                    fatalError("Failure to save context: \(error)")
                                }
                            }
                        }catch{
                            fatalError("Failure to save context: \(error)")
                        }
                        
                    }
                    
                  
                }catch let error as NSError{
                    print ("Errore nel parsing del JSON: \(error)")
                }
                
                print("Finished request aule")
                myGroup.leave()
            }
            
        }).resume()
        
        
        
                
        
                //download Edifici
                let destEdifici = URL(string: url+"edifici")
                URLSession.shared.dataTask(with: destEdifici!, completionHandler:{ (data,response,error) in
                    if error != nil {
                        print("Errore nella sessione: \(String(describing: error))")
                    }else{
                        do{
                            let jsonEdifici = try JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
                            
                            let moc = PersistenceManager.getContext()
                            let privateMoc2 = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                            privateMoc2.parent = moc
                            
                            privateMoc2.perform {
                                for edificio in jsonEdifici{
                                    
                                    let temp=PersistenceManager.newEmptyEdificio(context: privateMoc2)
                                    
                                    temp.nome=edificio["NOMEEDIFICIO"] as! String!
                                    temp.descrizione=edificio["DESCRIZIONEEDIFICIO"] as! String?
                                    temp.lat = Double(edificio["LATEDIFICIO"] as! String)!
                                    temp.long = Double(edificio["LONGEDIFICIO"] as! String)!
                                    
                                    
                                }
                                
                                do{
                                    try privateMoc2.save()
                                    moc.performAndWait {
                                        do {
                                            try moc.save()
                                        } catch{
                                            fatalError("Failure to save context: \(error)")
                                        }
                                    }
                                }catch{
                                    fatalError("Failure to save context: \(error)")
                                }
                                
                            }
                            
                            print("Finished request edifici")

                            myGroup.leave()

                        }catch let error as NSError{
                            print ("Errore nel parsing del JSON: \(error)")
                        }
                    }
                }).resume()
        
        //download Piani
        let destPiani = URL(string: url+"piani")
        URLSession.shared.dataTask(with: destPiani!, completionHandler:{ (data,response,error) in
            if error != nil {
                print("Errore nella sessione: \(String(describing: error))")
            }else{
                do{
                    let jsonPiani = try JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
                    
                    let moc = PersistenceManager.getContext()
                    let privateMoc3 = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    privateMoc3.parent = moc
                    
                    privateMoc3.perform {
                        for piano in jsonPiani{
                            
                            let temp=PersistenceManager.newEmptyPiano(context: privateMoc3)
                            
                            temp.edificio = piano["NOMEEDIFICIO"] as! String?
                            temp.numero = Int16(piano["NUMEROPIANO"] as! String)!
                            if let descrizione = piano["DESCRIZIONEPIANO"] as? String{
                                temp.descrizione = descrizione
                            }

                            
                            
                        }
                        
                        do{
                            try privateMoc3.save()
                            moc.performAndWait {
                                do {
                                    try moc.save()
                                } catch{
                                    fatalError("Failure to save context: \(error)")
                                }
                            }
                        }catch{
                            fatalError("Failure to save context: \(error)")
                        }
                        
                    }
                    
                    print("Finish piani")

                    myGroup.leave()

                }catch let error as NSError{
                    print ("Errore nel parsing del JSON: \(error)")
                }
            }
        }).resume()
        
        //download Beacon
        let destBeacon = URL(string: url+"beacon")
        URLSession.shared.dataTask(with: destBeacon!, completionHandler:{ (data,response,error) in
            if error != nil {
                print("Errore nella sessione: \(String(describing: error))")
            }else{
                do{
                    let jsonBeacon = try JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
                    
                    let moc = PersistenceManager.getContext()
                    let privateMoc4 = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    privateMoc4.parent = moc
                    
                    privateMoc4.perform {
                        for beacon in jsonBeacon{
                            let temp=PersistenceManager.newEmptyBeacon(context: privateMoc4)
                            
                            temp.aula = beacon["CODICEAULA"] as! String!
                            temp.minor = Int32((beacon["MINORBEACON"] as? String)!)!
                            temp.uuid = beacon["UUIDBEACON"] as! String!
                            temp.major = Int32(beacon["MAJORBEACON"] as! String!)!
                            
                        }
                        
                        do{
                            try privateMoc4.save()
                            moc.performAndWait {
                                do {
                                    try moc.save()
                                } catch{
                                    fatalError("Failure to save context: \(error)")
                                }
                            }
                        }catch{
                            fatalError("Failure to save context: \(error)")
                        }
                        print("Finished beacon")
                        
                        myGroup.leave()
                    }
                    

                    
                }catch let error as NSError{
                    print ("Errore nel parsing del JSON: \(error)")
                }
            }
        }).resume()
        
        myGroup.notify(queue: .main) {
            UserDefaults.standard.set(true, forKey: "registrazioneDevice")
            UserDefaults.standard.set(versioneDBvar, forKey: "versioneDB")
        }
    }
    
    
}


 





