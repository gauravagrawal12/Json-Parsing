//
//  ViewController.swift
//  JSON PARSING
//
//  Created by Felix 09 on 09/10/19.
//  Copyright © 2019 Felix. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gaurav.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.nameLbl?.text = gaurav[indexPath.row]
        let resource = ImageResource(downloadURL: URL(string: vivak[indexPath.row])!, cacheKey: vivak[indexPath.row])
        cell.imgView.kf.setImage(with: resource)
        return cell
    }
    
var gaurav = [String]()
    var vivak = [String]()
    enum JsonErrors:Error{
        case dataError
        case conversionError
    }
    
    @IBOutlet var tableview: UITableView!
   
    @IBOutlet var image_view: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseJson()
        print(gaurav)
        print(vivak)
       
        // Do any additional setup after loading the view.
    }

    func ParseJson()
    {
        
        let urlString = "https://api.github.com/repositories/19438/commits"
        let url:URL = URL(string:urlString)!
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        
        let dataTask = session.dataTask(with: url){ (data, response, error) in do {
            guard let data = data
                else{
                    throw JsonErrors.dataError
            }
            guard let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:Any]]
            else
            {
                throw JsonErrors.conversionError
            }
            for dic in array
            {
                let commitDic:[String:Any] = (dic["commit"] as? [String:Any])!
                 let authorDic:[String:Any] = (commitDic["author"] as? [String:Any])!
                let name:String = authorDic["name"] as! String
                self.gaurav.append(name)
                print(name)
            }
            for dic1 in array{
                let commitDic1:[String:Any] = (dic1["author"] as? [String:Any])!
                let avatar_url:String = commitDic1["avatar_url"] as! String
                self.vivak.append(avatar_url)
                print(avatar_url)
            }
        
           DispatchQueue.main.async {
                if self.gaurav.count>0 {
                self.tableview.reloadData()
            }
            }
        }
        
catch JsonErrors.dataError
{
    print("data error \(error?.localizedDescription)")
            }
            catch JsonErrors.conversionError
            {
                print("conversion error \(error?.localizedDescription)")
        }
            catch let error
            {
                print(error.localizedDescription)
            }
}
dataTask.resume()
}
   
}
