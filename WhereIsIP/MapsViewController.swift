//
//  MapsViewController.swift
//  WhereIsIP
//
//  Created by Tongchai Tonsau on 4/27/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import GoogleMaps
import FBSDKLoginKit
import Google
import GoogleSignIn

class MapsViewController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate{
// open func signOut()
   
  
    @IBOutlet weak var goto_history: UIBarButtonItem!
    @IBOutlet weak var longti: UILabel!
    @IBOutlet weak var continent: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var lalong: UILabel!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var googleMapview: UIView!
    @IBOutlet weak var Text_IP: UITextField!
    var ip : String = "no ip"
  
    var login_with = ""
    var getCity : String!
    var getCountry : String!
    
    var getLatitude : Double = 0.00
    var getLongitude : Double = 0.00
    
    var getContinent : String!
    var historyData = [String]()
    var stringerror = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        status.text = ""
        logout.title = ("Logout: " + login_with)
       
    
        let camera = GMSCameraPosition.camera(withLatitude: 18.705581, longitude:  98.982084, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.googleMapview.bounds, camera: camera)
        self.googleMapview.addSubview(mapView)
        if ip != "no ip"
        {
            
            getJson()
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) {
            self.markPoint()
            }
        }

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    @IBAction func logout_action(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? ViewController
        if login_with == "facebook"
        {
             vc?.logout = "facebook"
        }
        else
        {
            vc?.logout = "google"
        }
       
        self.present(vc!, animated: true, completion: nil)

      
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Search_Btn(_ sender: Any) {
        if (Text_IP.text == "")
        {
            let alertController = UIAlertController(title: "Error", message: "Please enter Yours IP or Hostname", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)

        }

            
        else
        {
            getLatitude = 0.00
            getLongitude = 0.00
            status.text = "Loading"
            ip = Text_IP.text!
            checkString()
            if(stringerror == false)
            {
                getJson()
            }
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.status.text = "Press the marker for show location"
                
                if(self.getLatitude == 0.00 && self.getLongitude == 0.00)
                {
                    self.status.text = "Can't get place : Please search again"
                    self.Text_IP.text = ""
                }
                else
                {
                    self.markPoint()
                    
                    let defaults = UserDefaults.standard
                    if let ShowIP = defaults.stringArray(forKey: "IP"){
                        print(ShowIP)
                        self.historyData = ShowIP
                    }
                    
                    if self.checkArray(Array: self.historyData, Data: self.Text_IP.text!) == false
                    {
                        self.historyData.append(self.Text_IP.text!)
                        self.Text_IP.text = ""
                        
                        defaults.set(self.historyData, forKey: "IP")
                        print(self.historyData.count)
                        
                    }
                    else
                    {
                        self.Text_IP.text = ""
                    }
                    
                }
                
            }

            
 
        }
        
    }
    func markPoint()
    {
        let camera = GMSCameraPosition.camera(withLatitude: self.getLatitude, longitude: self.getLongitude, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.googleMapview.bounds, camera: camera)
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.getLatitude , longitude: self.getLongitude)
        marker.title = self.getCountry
        marker.snippet = self.getCity
        marker.map = mapView
        self.googleMapview.addSubview(mapView)
        
        continent.text = ("RegionName: " + getContinent)
        lalong.text = "Latitude: \(getLatitude)"
        longti.text = "Longitude: \(getLongitude)"
        

        
    }
    func checkArray(Array: [String] ,Data: String) -> Bool{
        var check = false
        for i in Array{
            if i == Data
            {
                check = true
            }
    
        }
        return check
    }
    
    @IBAction func history_btn(_ sender: Any) {
        

        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "History") as? historyViewController
        self.present(vc!, animated: true, completion: nil)
        
    }

    
    
    func getJson(){
        let url = URL(string: "http://ip-api.com/json/" + ip )
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    do
                    {
                        //Array
                        let result = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        //print(result)
                        if let status = result["status"]
                        {
                            let sta = status as! String
                            if sta == "success"
                            {
                                if let latitudes = result["lat"]
                                {
                                    self.getLatitude = (latitudes as! Double)
                                    print (self.getLatitude )
                                    
                                }
                                if let longitudes = result["lon"]
                                {
                                    self.getLongitude = (longitudes as! Double)
                                    print (self.getLongitude )
                                    
                                }
                                if let city = result["city"]
                                {
                                    self.getCity = city as! String
                                    print (self.getCity)
                                }
                                if let country = result["country"]
                                {
                                    self.getCountry = country as! String
                                    print (self.getCountry)
                                }
                                if let continent = result["regionName"]
                                {
                                    self.getContinent = continent as! String
                                    print (self.getContinent)
                                }

                                
                            }
                    
                        }
                        
                        print("success download json")
                           

                    }
                    catch
                    {
                        
                    }
                }
            }
        }
        task.resume()
        
    }
    func checkString(){
        stringerror = false
        for i in ip.characters{
            if i.description == " " {
                stringerror = true
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.Text_IP.resignFirstResponder()
        self.Text_IP.resignFirstResponder()
        return true
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
