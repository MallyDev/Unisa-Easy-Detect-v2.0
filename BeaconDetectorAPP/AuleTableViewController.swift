//
//  AuleTableViewController.swift
//  BeaconDetectorAPP
//
//  Created by Mario Cantalupo on 07/07/2017.
//  Copyright © 2017 Marco Capozzo. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

class AuleTableViewController: UITableViewController,UITextFieldDelegate,UISearchResultsUpdating, UISearchBarDelegate {
    
    
    var resultSearchController: UISearchController?
    
    
    var list : [PAula]!
    var filtered = [PAula]()
    var cellModified = AulaTableViewCell()
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    var edificiNumber: Int = 0
    var edifici:[PEdificio] = []
    
    var auleInEdifici = [String: [PAula]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Aule"
        self.definesPresentationContext = true
        self.resultSearchController = ({
            tableView.delegate = self

            //Creo un oggetto di tipo UISearchController
            let controller = UISearchController(searchResultsController: nil)
            
            //Rimuove la tableView di sottofondo in modo da poter successivamente visualizzare gli elementi cercati
            controller.dimsBackgroundDuringPresentation = false
            
            //Il searchResultsUpdater, ovvero colui che gestirà gli eventi di ricerca, sarà la ListaTableViewController (o self)
            controller.searchResultsUpdater = self
            
            //Impongo alla searchBar, contenuta all'interno del controller, di adattarsi alle dimensioni dell'applicazioni
            controller.searchBar.sizeToFit()
            
            //Attacco alla parte superiore della TableView la searchBar
            DispatchQueue.main.async {
                self.navigationItem.titleView = controller.searchBar
            }
            
            controller.hidesNavigationBarDuringPresentation = false
            
            controller.searchBar.delegate = self
            
            // restituisco il controller creato
            return controller
            
        })()

         NotificationCenter.default.addObserver(self, selector: #selector(AuleTableViewController.updateTable), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        
}
    
    public func updateSearchResults(for searchController: UISearchController) {
        self.filtraContenuti(testoCercato: searchController.searchBar.text!, scope: "Tutti")
    }
    
    
    //Funzione che filtra la lista di Aule
    func filtraContenuti(testoCercato: String, scope: String) {
        if testoCercato == "" {
            filtered.removeAll(keepingCapacity: true)
            filtered.append(contentsOf: list)
            self.tableView.reloadData()
        } else {
            filtered.removeAll(keepingCapacity: true)
            for x in list {
                if (scope == "Tutti") {
                    if (x.nome?.localizedLowercase.range(of: testoCercato.localizedLowercase) != nil) {
                        filtered.append(x)
                    }
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //aggiornamento della table view, considerando gli edifici presenti e l'appartenenza delle aule ad essi
        
        list = PersistenceManager.fetchAllAule()
        list.sort(by: {$0.nome! < $1.nome!})
        if list.count == 0{
            let noDataLabel = UILabel()
            noDataLabel.text          = "Non ci sono aule"
            noDataLabel.textColor     = UIColor(colorLiteralRed: 63.0/255.0, green: 176.0/255.0, blue: 252.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle  = .none
        }else{
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle  = .singleLine
            
            
            edificiNumber = 0
            edifici = []
            auleInEdifici = [String: [PAula]]()
            
            self.edificiNumber = PersistenceManager.fetchAllEdifici().count
            
            self.edifici = PersistenceManager.fetchAllEdifici().sorted(by: {$0.nome! < $1.nome!})
            
            
            var auleInEdificiTemp = [String: [PAula]]()
            
            for aula in list {
                if auleInEdificiTemp[aula.edificio!] == nil {
                    auleInEdificiTemp[aula.edificio!] = [PAula]()
                }
                auleInEdificiTemp[aula.edificio!]!.append(aula)
                
            }
            
            for (edificio, lista) in auleInEdificiTemp {
                auleInEdificiTemp[edificio] = lista.sorted { $0.nome! < $1.nome! }
            }
            self.auleInEdifici = auleInEdificiTemp
        }
        
        
        
        tableView.reloadData()

        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let controller = self.resultSearchController else {
            return 0
        }
        if controller.isActive {
            return 1
        } else {
            return self.edificiNumber
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let controller = self.resultSearchController else {
            return ""
        }
        if controller.isActive {
            return ""
        } else {
            return "Edificio \(String(describing: edifici[section].nome!))"
        }

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let controller = self.resultSearchController else {
            return 0
        }
        if controller.isActive {
            return self.filtered.count
        } else {
            
            return (auleInEdifici[edifici[section].nome!]?.count)!
            
        }
       
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filtraContenuti(testoCercato: "", scope: "Tutti")
        tableView.reloadData()
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "auleListCell", for: indexPath) as! AulaTableViewCell
        // Configure the cell...
        let aula : PAula
        if self.resultSearchController!.isActive {
            aula = filtered[indexPath.row]
        } else {
            aula = (auleInEdifici[edifici[indexPath.section].nome!]?[indexPath.row])!
        }
        
        
        cell.nomeAulaLabel.text = aula.nome!
        
       let location = "Piano: \(aula.piano)"
        cell.locationAulaLabel.text = location
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        let nomeAula = "\(aula.nome!)_\(aula.codice!)"
        let id = Utility.creazioneOrario()
        //Verifica disponibilità aula, se in orario utile
        if (id != ""){
            var url = "http://193.205.163.43/beaconDetector/src/public/orario/\(nomeAula)/\(id)"
            url = url.replacingOccurrences(of: " ", with: "")
            print(url)
            //download orario
            let destOrario = URL(string: url)
            
            if(destOrario != nil){
            session.dataTask(with: destOrario!, completionHandler:{ (data,response,error) in
                if error != nil {
                    print("Errore nella sessione: \(String(describing: error))")
                }else{
                    if let dataVar = data {
                        let returnData = String(data: dataVar, encoding: .utf8)
                        if(returnData! != "\n"){
                        OperationQueue.main.addOperation {
                            if(returnData! == "\nAula Libera"){
                                cell.accessoryType = .checkmark
                                cell.tintColor = UIColor.green
                                
                            }else{
                                cell.accessoryType = .checkmark
                                cell.tintColor = UIColor.red
                            }
                        }
                        }
                    }
                }
            }).resume()
            }
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAula" {
            let dstView = segue.destination as! AulaViewController
            let currentSection = self.tableView.indexPathForSelectedRow!.section
            let currentRow = self.tableView.indexPathForSelectedRow!.row
            
            if self.resultSearchController!.isActive {
                dstView.title = filtered[currentRow].nome!
                dstView.aulaCorrente = filtered[currentRow]
            } else {
                dstView.title = (auleInEdifici[edifici[currentSection].nome!]?[currentRow])!.nome!
                dstView.aulaCorrente = (auleInEdifici[edifici[currentSection].nome!]?[currentRow])!
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.resultSearchController!.isActive=false
        super.viewWillDisappear(animated)
    }
    
    func updateTable(notification: NSNotification){
        
        //aggiornamento tabella quando la view entra in foreground
        
        list = PersistenceManager.fetchAllAule()
        list.sort(by: {$0.nome! < $1.nome!})
        if list.count == 0{
            let noDataLabel = UILabel()
            noDataLabel.text          = "Non ci sono aule"
            noDataLabel.textColor     = UIColor(colorLiteralRed: 63.0/255.0, green: 176.0/255.0, blue: 252.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle  = .none
        }else{
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle  = .singleLine
            
            
            edificiNumber = 0
            edifici = []
            auleInEdifici = [String: [PAula]]()
            
            self.edificiNumber = PersistenceManager.fetchAllEdifici().count
            
            self.edifici = PersistenceManager.fetchAllEdifici().sorted(by: {$0.nome! < $1.nome!})
            
            
            var auleInEdificiTemp = [String: [PAula]]()
            
            for aula in list {
                if auleInEdificiTemp[aula.edificio!] == nil {
                    auleInEdificiTemp[aula.edificio!] = [PAula]()
                }
                auleInEdificiTemp[aula.edificio!]!.append(aula)
                
            }
            
            for (edificio, lista) in auleInEdificiTemp {
                auleInEdificiTemp[edificio] = lista.sorted { $0.nome! < $1.nome! }
            }
            self.auleInEdifici = auleInEdificiTemp
        }
        
        
        
        tableView.reloadData()
    }
}


