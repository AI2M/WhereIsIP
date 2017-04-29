//
//  historyViewController.swift
//  WhereIsIP
//
//  Created by Tongchai Tonsau on 4/29/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit

class historyViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var list: UITableView!
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var Hostname = [String]()
    var Ip = [String]()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let ShowIP = defaults.stringArray(forKey: "IP"){
            print(ShowIP)
            self.Ip = ShowIP
        }
        

        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Ip.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = Ip[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Map") as? MapsViewController
        
        vc?.ip = Ip[indexPath.row]
        
        self.present(vc!, animated: true, completion: nil)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
