//
//  ViewController.swift
//  swiftyCompanion
//
//  Created by Миша on 16.09.2021.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    
    var auth = Token()
    @IBOutlet weak var timeLabel: UILabel!
    var user: User?
    var count: Int = UserDefaults.standard.integer(forKey: "tokenLive")
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = nil
        searchController.searchBar.text = nil
        searchController.hidesNavigationBarDuringPresentation = true
        searchBarTextDidEndEditing(searchController.searchBar)
        searchController.searchBar.tintColor = .white
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        auth.getToken()
        timerAdd()
    }

    private func setupSearchBar(){
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255,  green: 40/255, blue: 130/255, alpha: 1)
        searchBar.tintColor = .white
        
    }
    
    func tableView(user: User?){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let userDetailsViewController = storyboard.instantiateViewController(identifier: "UserDetailsViewController") as! UserDetailsViewController
       
        userDetailsViewController.user = user
        
        navigationController?.pushViewController(userDetailsViewController, animated: true)
    }
    
    
    @IBAction func updateTokenAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "tokenLife")
        auth.getToken()
        count = UserDefaults.standard.integer(forKey: "tokenLive")
    }
    
    func timerAdd() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    @objc func timerCounter() -> Void {
        if count > 0 {
            count -= 1
        }
        let time = secToHMS(sec: count)
        let timeStr = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timeLabel.text = timeStr
    }
    
    func secToHMS(sec: Int) -> (Int, Int, Int) {
        return ((sec / 3600), ((sec % 3600) / 60), ((sec % 3600) % 60))
    }
    
    func makeTimeString(hour : Int, min : Int, sec : Int) -> String {
        var timeString = "Token "
        timeString += String(format: "%02d", hour)
        timeString += String(" : ")
        timeString += String(format: "%02d", min)
        timeString += String(" : ")
        timeString += String(format: "%02d", sec)
        
        return timeString
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let login = searchBar.text?.lowercased() else { return }
        
        auth.checkUserName(userName: login) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    self.tableView(user: self.user)
                case .failure(let err):
                    self.showErr(error: err as! ApiErr)
                    return
                }
            }
        }
    }
    
    
    func showErr (error: ApiErr) {
        guard let logIn = searchController.searchBar.text?.lowercased() else { return }
        
        var message = ""
        
        switch error {
        case .noData:
            message = "No data"
        case .unowned:
            message = "login '\(logIn)' incorrect. Try again."
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        searchController.searchBar.text = nil
    }
    
}

    

