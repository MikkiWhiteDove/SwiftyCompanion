//
//  ProjSkilViewController.swift
//  swiftyCompanion
//
//  Created by Миша on 19.09.2021.
//

import UIKit

class ProjSkilViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var downTableView: UITableView!
    
    
    var user: User?
    var topData: [String] = []
    var topDataRes: [String] = []
    var downData = [String]()
    var downDataRes: [String] = []
    
    var courses: Cursus?
    var valid: [Bool?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTableView.delegate = self
        downTableView.delegate = self
        topTableView.dataSource = self
        downTableView.dataSource = self
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.title = nil
        }
        
        
        for index in courses!.skills {
            topData.append(index.nameSkills)
            let doub = String(format: "%.2f", index.lavelSlills)
            topDataRes.append(doub)
            
        }
        
        guard let projects = self.user?.prjectsUsers else {
            return
        }
        
        for index in projects {
            if(index.curses_id.first == courses?.curcusName.id) {
                if (index.projectName.parentId == nil) {
                downData.append("\(index.projectName.name)")
                    if index.validated != nil {
                        guard let b = index.finalMark  else{
                            return
                            
                        }
                        valid.append(index.validated)
                        downDataRes.append("\(b)")
                    }else {
                        valid.append(index.validated)
                        downDataRes.append("\(index.status)")
                    }
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case topTableView:
            return "Skills"
        case downTableView:
            return "Projects"
        default:
            print("default: Nil")
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        
        switch tableView {
        case topTableView:
            numberOfRow = topData.count
        case downTableView:
            numberOfRow = downData.count
        default:
            print("default: INT")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        var cellProj = ProjViewCell()
        
        switch tableView {
        case topTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
            cell.textLabel?.text = topData[indexPath.row]
            cell.detailTextLabel?.text = "\(topDataRes[indexPath.row])"
        case downTableView:
            cellProj = downTableView.dequeueReusableCell(withIdentifier: "downCell", for: indexPath) as! ProjViewCell
        
            cellProj.nameProjLab.text = "\(downData[indexPath.row])"
            cellProj.infoProjLab.text = "\(downDataRes[indexPath.row])"
            
            let valid = valid[indexPath.row]
            
            if  valid != nil{
                if valid == true{
                    cellProj.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                }else {
                    cellProj.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                }
            }else{
                cellProj.backgroundColor = #colorLiteral(red: 1, green: 0.5868047476, blue: 0, alpha: 1)
            }
            
            return cellProj
        default:
            print("default: Cell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
