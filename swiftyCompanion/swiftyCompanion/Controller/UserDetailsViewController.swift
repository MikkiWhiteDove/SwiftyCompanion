//
//  UserDetailsViewController.swift
//  swiftyCompanion
//
//  Created by Миша on 16.09.2021.
//

import UIKit

class UserDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user: User?
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var campus: UILabel!
    @IBOutlet weak var available: UILabel!
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var titlesUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (self.user?.login)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.main.async {
            self.loadUserData()
            self.loadPhoto()
            self.maxLevel()
            self.titleUserName()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    func loadUserData() {
        guard let usWallet = self.user?.wallet else {return}
        wallet.text = "Wallet: \(usWallet)"
        guard let corPoints = self.user?.correctionPoint else {return}
        points.text = "Evaluation points: \(corPoints)"
        guard let usCampus = self.user?.campus.first?.city else {return}
        campus.text = "Campus \(usCampus)"
        guard let location = self.user?.location else {
            available.text = "Unavailable\n-"
            return
        }
        available.text = "Available \(location)"
        
    }
    
    func titleUserName() {
        guard let userName = user?.userFullName else {
            return
        }
        fullName.text = "\(userName)"
        
        let titl = user?.titleUsers.first?.nameTitle
        
        guard let login = self.user?.login else {
            return
        }
        if titl != nil {
            let titleCount = self.user?.titleUsers.count
            for i in 0...titleCount! - 1 {
                if user!.titleUserId[i].selectTitle == true {
                    guard let title = self.user?.titleUsers[i].nameTitle else {
                        return
                    }
                    let replaced = title.replacingOccurrences(of: "%login", with: login)
                    titlesUser.text = "\(replaced)"
                }
            }
        }else{
            titlesUser.text = ""
        }
    }
    
    func maxLevel(){
        guard let coun = user?.cursusUsers.count else {
            return
        }
        guard var cursLevelMax:Double = user?.cursusUsers.first?.level else {
            return
        }
        for i in 0...coun - 1 {
            guard let usr = user?.cursusUsers[i].level else {
                return
            }
            if (user?.cursusUsers[i] != nil && usr > cursLevelMax){
                cursLevelMax = user!.cursusUsers[i].level
            }
        }
        let int = Int(Float(cursLevelMax) * 100)
        self.level.text = "Level \(int / 100) - \(int % 100)%"
        self.progressBar.progress = Float(int % 100)/100
    }
    
    func loadPhoto() {
        guard let strUrl = user?.imageUrl else {return}
        if let url = URL(string: strUrl) {
            if let data = NSData(contentsOf: url) {
                photo.image = UIImage(data: data as Data)
                photo.layer.cornerRadius = 20
            } else {
                photo.image = #imageLiteral(resourceName: "knuckle")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.user!.cursusUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        let courses = self.user?.cursusUsers[indexPath.row]
        
        let numSkill = courses?.skills.count
        let resSkill = [courses?.skills]
        
        let name = courses!.curcusName.nameCurcus
        let level = courses!.level
        
        cell.textLabel?.text = name
        
        cell.detailTextLabel?.text = "\(level)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let projSkilViewController = storyboard.instantiateViewController(identifier: "ProjSkilViewController") as! ProjSkilViewController
        
        projSkilViewController.user = user
        projSkilViewController.courses = self.user?.cursusUsers[indexPath.row]
        
        navigationController?.pushViewController(projSkilViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
