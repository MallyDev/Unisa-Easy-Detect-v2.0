//
//  Utility.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 12/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import Foundation

class Utility{
    
    
    //Metodo che controlla se il dispositivo dell'utente è connesso alla rete
    static func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    //Creazione parte finale url per verificare la disponibilità delle aule
    
    static func creazioneOrario() -> String{
        
        let timestamp = Date.init()
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "Europe/Rome")! as TimeZone
        
        let giornoSettimana = dateFormatter.calendar.component(.weekday, from: timestamp)
        let giorno = Int(giornoSettimana)-2
        
        let orarioOra = dateFormatter.calendar.component(.hour, from: timestamp)
        let orarioMinuti = dateFormatter.calendar.component(.minute, from: timestamp)
        
        var orarioCella = -1
        if(giorno>=0 && giorno<=4){
            
        switch(orarioOra){
        case 8:
            if(orarioMinuti>=30){
                orarioCella = 0
            }
        case 9:
            if(orarioMinuti>=30){
                orarioCella = 1
            }else{
                
                orarioCella = 0
            }
        case 10:
            if(orarioMinuti>=30){
                orarioCella = 2
            }else{
                
                orarioCella = 1
            }
        case 11:
            if(orarioMinuti>=30){
                orarioCella = 3
            }else{
                
                orarioCella = 2
            }
        case 12:
            if(orarioMinuti>=30){
                orarioCella = 4
            }else{
                
                orarioCella = 3
            }
        case 13:
            if(orarioMinuti>=30){
                orarioCella = 5
            }else{
                
                orarioCella = 4
            }
        case 14:
            if(orarioMinuti>=30){
                orarioCella = 6
            }else{
                
                orarioCella = 5
            }
        case 15:
            if(orarioMinuti>=30){
                orarioCella = 7
            }else{
                
                orarioCella = 6
            }
        case 16:
            if(orarioMinuti>=30){
                orarioCella = 8
            }else{
                
                orarioCella = 7
            }
        case 17:
            if(orarioMinuti>=30){
                orarioCella = 9
            }else{
                
                orarioCella = 8
            }
        case 18:
            if(orarioMinuti<=30){
                orarioCella = 9
            }
        default: break
            
        }
    }
        if(orarioCella != -1){
            return "\(giorno)_\(orarioCella)"
            
        }
        else{
            return ""
        }
            
}


    //Verifica versione del DB
    
    static func verificaAggiornamenti()
    {
        let urlString = "http://193.205.163.43/beaconDetector/src/public/versioneDB"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if error != nil{
                print("Errore durante la connessione. \(String(describing: error))")
                
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200{
                    if let dataVar = data {
                        let string = String(data: dataVar, encoding: .utf8)!
                        let versioneDBString = string.replacingOccurrences(of: "\n", with: "")
                        let versioneDB = Double(versioneDBString)
                        let versioneCorrente = UserDefaults.standard.double(forKey: "versioneDB")
                        if( versioneDB! > versioneCorrente){
                            PersistenceManager.deleteAll()
                            DataBaseManager.databaseDownload()
                            UserDefaults.standard.set(versioneDB!, forKey: "versioneDB")

                        }
                    }
                }
            }
            
        }
        task.resume()
    }


}
