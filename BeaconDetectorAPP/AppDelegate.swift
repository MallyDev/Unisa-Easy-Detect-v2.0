//
//  AppDelegate.swift
//  beaconDetector
//
//  Created by Mario Cantalupo on 06/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import UserNotifications

typealias CompletionHandler = () -> Void


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,UNUserNotificationCenterDelegate, ESTBeaconManagerDelegate, URLSessionDelegate{
    
    var window: UIWindow?
   
    var locationManager = CLLocationManager()
    var beaconManager = ESTBeaconManager()
    
    var center = UNUserNotificationCenter.current()

    var versioneDBOnline:Double?
    
    
    //Gestione CoreData aule
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "beaconDetectorDB")
        container.loadPersistentStores(completionHandler: { (storeDescription,error) in
            if let error = error as NSError?{
                fatalError("Unresolved error in loading the container. \(error)")
            }
        })
        return container
    }()
    
   
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            } catch  {
                let nserror = error as NSError
                fatalError("Fatal error in saving context. \(nserror)")
            }
        }
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            let navigationBarAppearance = UINavigationBar.appearance()
       
            navigationBarAppearance.barTintColor = UIColor(red: 1, green: 0.549, blue: 0, alpha: 1.0)
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        
            beaconManager.delegate = self
            beaconManager.requestWhenInUseAuthorization()        
        
        
        /*
        //Richiede il permesso per le notifiche locali
        self.center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        */
        // Override point for customization after application launch.

        //Verifica se il database è stato già scaricato precedentemente (da implementare con versione database)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Verifica se il dispositivo è stato già registrato decidendo la prima View da mostrare
        let rootViewController = storyboard.instantiateViewController(withIdentifier: UserDefaults.standard.bool(forKey: "registrazioneDevice") ? "tabBarController" : "firstViewController")
        
        window?.rootViewController = rootViewController
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
            }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if(Utility.connectedToNetwork()){
            
            let presenza = PresenzaViewController.aula
            
            if((presenza != nil)){
                
            }else{
                DispatchQueue.global(qos: .background).async {
                    
                    let urlString = "http://193.205.163.43/beaconDetector/src/public/versioneDB"
                    let url = NSURL(string: urlString)!
                    let request = NSMutableURLRequest(url: url as URL)
                    
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                        if error != nil{
                            print("Errore nella registrazione dell'id dell'utente. \(String(describing: error))")
                            
                        }
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 200{
                                if let dataVar = data {
                                    let string = String(data: dataVar, encoding: .utf8)!
                                    let versioneDBString = string.replacingOccurrences(of: "\n", with: "")
                                    let versioneDB = Double(versioneDBString)
                                    let versioneCorrente = UserDefaults.standard.double(forKey: "versioneDB")
                                    if( versioneDB! > versioneCorrente){
                                        UserDefaults.standard.set(0.0, forKey: "versioneDB")
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        //Verifica se il dispositivo è stato già registrato decidendo la prima View da mostrare
                                        OperationQueue.main.addOperation {
                                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "firstViewController")
                                            
                                            
                                            
                                            
                                            self.window?.rootViewController = rootViewController
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                    task.resume()
                }
                
            }
        }

      
    }
    
    //Metodo che controlla se il dispositivo è collegato ad internet, altrimenti lancia un alert che permette di accedere alle opzioni per poter attivare la connessione oppure di continuare l'esecuzione dell'applicazione
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if !Utility.connectedToNetwork(){
            let alert = UIAlertController(title: "Attenzione", message: "Attivare la connessione ad internet per sincronizzare i dati e inviare le presenze.", preferredStyle: UIAlertControllerStyle.alert)
            let settingsAction = UIAlertAction(title: "Impostazioni", style: .default) { (_) -> Void in
                
                UIApplication.shared.open(URL(string:"App-Prefs:root=WIFI")!, options: [:], completionHandler: nil)
            }
            alert.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Chiudi", style: .destructive,handler: nil)
            alert.addAction(cancelAction)
            self.window!.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    }
    
}

