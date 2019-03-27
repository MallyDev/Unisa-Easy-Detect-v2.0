//
//  PersistanceManager.swift
//  beaconDetector
//
//  Created by Mario Cantalupo on 07/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PersistenceManager{

    
    static func getContext() -> NSManagedObjectContext{
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    static func newEmptyAula(context: NSManagedObjectContext) ->PAula{
        let aula = NSEntityDescription.insertNewObject(forEntityName: "PAula", into: context) as! PAula
        aula.capienza = 0
        aula.codice = ""
        aula.descrizione = ""
        aula.edificio = ""
        aula.lat = 0.0
        aula.long = 0.0
        aula.nome = ""
        aula.piano = 0
        
        return aula
    }
    
    static func newEmptyPiano(context: NSManagedObjectContext) -> PPiano{
        
        let piano = NSEntityDescription.insertNewObject(forEntityName: "PPiano", into: context) as! PPiano
        piano.descrizione = ""
        piano.edificio = ""
        piano.numero = 0
        
        return piano
    }
    
    static func newEmptyBeacon(context: NSManagedObjectContext) -> PBeacon{
        
        let beacon = NSEntityDescription.insertNewObject(forEntityName: "PBeacon", into: context) as! PBeacon
        beacon.aula = ""
        beacon.major = 0
        beacon.minor = 0
        beacon.uuid = ""
        
        return beacon
        
    }
    
    
    static func newEmptyEdificio(context: NSManagedObjectContext) -> PEdificio{
        let edificio = NSEntityDescription.insertNewObject(forEntityName: "PEdificio", into: context) as! PEdificio
        edificio.descrizione = ""
        edificio.lat = 0.0
        edificio.long = 0.0
        edificio.nome = ""
        
        return edificio
        
    }
    
    static func newEmptyUtente(context: NSManagedObjectContext) -> PUtente{
        let utente = NSEntityDescription.insertNewObject(forEntityName: "PUtente", into: context) as! PUtente
        utente.nome = ""
        utente.matr = ""
        utente.cdl = ""
        utente.anno = ""
        
        return utente
        
    }
    
    //Restituisce la lista di tutte le aule
    static func fetchAllAule()->[PAula]{
        let context = getContext()
        var aule=[PAula]()
        let fetchRequest = NSFetchRequest<PAula>(entityName: "PAula")
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false)]
        
        do{
            try aule=context.fetch(fetchRequest)
        } catch let error as NSError{
            fatalError("Error in fetching Aule. \(error)")
        }
        return aule
    }
    
    //Restituisce la lista di tutti i Beacon
    static func fetchAllBeacon()->[PBeacon]{
        let context = getContext()
        var beacon=[PBeacon]()
        let fetchRequest = NSFetchRequest<PBeacon>(entityName: "PBeacon")
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false)]
        
        do{
            try beacon=context.fetch(fetchRequest)
        } catch let error as NSError{
            fatalError("Error in fetching Beacon. \(error)")
        }
        return beacon
    }
    
    //Restituisce la lista di tutti gli edifici
    static func fetchAllEdifici()->[PEdificio]{
        let context = getContext()
        var edifici=[PEdificio]()
        let fetchRequest = NSFetchRequest<PEdificio>(entityName: "PEdificio")
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false)]
        
        do{
            try edifici=context.fetch(fetchRequest)
        } catch let error as NSError{
            fatalError("Error in fetching Edifici. \(error)")
        }
        return edifici
    }
    
    //Restituisce la lista di tutti i piani
    static func fetchAllPiani()->[PPiano]{
        let context = getContext()
        var piani=[PPiano]()
        let fetchRequest = NSFetchRequest<PPiano>(entityName: "PPiano")
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false)]
        
        do{
            try piani=context.fetch(fetchRequest)
        } catch let error as NSError{
            fatalError("Error in fetching Piani. \(error)")
        }
        return piani
    }
    
    static func fetchUtente()->PUtente?{
        let context = getContext()
        var utente: [PUtente]?
        let fetchRequest = NSFetchRequest<PUtente>(entityName: "PUtente")
        
        do{
            try utente=context.fetch(fetchRequest)
        } catch let error as NSError{
            fatalError("Error in fetching Utente. \(error)")
        }
        
        if(utente?.count != 0){
            return utente![0]
        }else{
            return nil
        }
    }
    
     //Ricerca di un'aula e restituisce l'aula se trovata altrimenti nil
    static func searchAula (codiceAula: String) -> (PAula?) {
        let context = getContext()
        var aula : [PAula]?
        
        let fetchRequest = NSFetchRequest<PAula>(entityName: "PAula")
        fetchRequest.predicate = NSPredicate(format: "codice like %@",codiceAula)
        
        do {
            try aula = context.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Error in searching Aula. \(error)")
        }
        
        return (aula?[0])
    }
    
    //Ricerca di un edificio e restituisce l'edificio e un booleano in base al successo della ricerca
    static func searchEdificio (nomeEdificio: String) -> (PEdificio?) {
        let context = getContext()
        var edificio : [PEdificio]?
        
        let fetchRequest = NSFetchRequest<PEdificio>(entityName: "PEdificio")
        fetchRequest.predicate = NSPredicate(format: "nome == \(nomeEdificio)")
        
        do {
            try edificio = context.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Error in searching the Edificio. \(error)")
        }
        
        
        return (edificio?[0])
    }
    
    
    //Ricerca di un'aula in base al Beacon e restituisce l'aula e un booleano in base al successo della ricerca
    static func searchAulaBeacon (UUID: String,major: Int32,minor: Int32) -> (PAula?) {
        let context = getContext()
        var beacon : [PBeacon]?
        
        let fetchRequest = NSFetchRequest<PBeacon>(entityName: "PBeacon")
        fetchRequest.predicate = NSPredicate(format: "(uuid like %@) AND (major = %@) AND (minor = %@)",UUID,NSNumber(value: major),NSNumber(value:minor))
        do {
            try beacon = context.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Error in searching the Aula. \(error)")
        }
        
        if(beacon?.count != 0){
            
        return (self.searchAula(codiceAula: (beacon?[0].aula!)!))
        }else{
            print("Nessun beacon registrato rilevato")
        return nil
        }
    }
    
    //Salva tutte le modifiche effettuate
    static func saveContext(){
        let context = getContext()
        
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error in saving context. \(error)")
        }
    }
    
    static func deleteAll(){
        let aule = PersistenceManager.fetchAllAule()
        let edifici = PersistenceManager.fetchAllEdifici()
        let piani = PersistenceManager.fetchAllPiani()
        let beacon = PersistenceManager.fetchAllBeacon()
        
        for el in aule{
            let context = getContext()

            context.delete(el)
            PersistenceManager.saveContext()
        }
        for el in edifici{
            let context = getContext()

            context.delete(el)
            
            PersistenceManager.saveContext()
        }
        for el in piani{
            let context = getContext()

            context.delete(el)
            
            PersistenceManager.saveContext()
        }
        for el in beacon{
            let context = getContext()
            context.delete(el)

            PersistenceManager.saveContext()
        }
        
    }
    
    static func deleteUtente(){
        let context = getContext()
        let utente = PersistenceManager.fetchUtente()
        
        if(utente != nil){
            context.delete(utente!)
            PersistenceManager.saveContext()
        }
    }
}
