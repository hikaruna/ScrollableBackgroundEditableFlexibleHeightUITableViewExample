//
//  ViewController.swift
//  myios
//
//  Created by 中川輝 on 2017/11/09.
//  Copyright © 2017年 hikaruna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct CellModel {
        let title: String
        let subTitle: String
    }
    
    @IBOutlet weak var tableView: UITableView!
    private var model: [CellModel] = [
        CellModel(title: "hoge", subTitle: ""),
    ]

    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...40 {
            model.append(CellModel(title: "title\(i)", subTitle: ""))
        }
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.layoutIfNeeded()
        tableHeight.constant = tableView.contentSize.height
    }
    
    @IBAction func onValueChanged(_ sender: UISwitch) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let lastIndexPath = IndexPath(row: self.model.count, section: 0)
            if sender.isOn {
                self.tableView.insertRows(at: [lastIndexPath], with: .automatic)
            } else {
               self.tableView.deleteRows(at: [lastIndexPath], with: .automatic)
            }
            self.tableHeight.constant = self.tableView.contentSize.height
        }
        tableView.setEditing(sender.isOn, animated: true)
        CATransaction.commit()
    }
    
    @IBAction func onReloadButtonTapped(_ sender: Any) {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableHeight.constant = tableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing && indexPath.row == model.count {
            return .insert
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .insert:
            let cell = tableView.cellForRow(at: indexPath)
            let cellModel = CellModel(title: cell?.textLabel?.text ?? "", subTitle: cell?.detailTextLabel?.text ?? "")
            model.insert(cellModel, at: indexPath.row)
            tableView.reloadData()
            tableHeight.constant = tableView.contentSize.height
        case .delete:
            model.remove(at: indexPath.row)
            tableView.reloadData()
            tableView.layoutIfNeeded()
            tableHeight.constant = tableView.contentSize.height
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEditing {
            return model.count + 1
        }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row == model.count {
            cell.textLabel?.text = "new"
            cell.detailTextLabel?.text = nil
        } else {
            cell.textLabel?.text = model[indexPath.row].title
            cell.detailTextLabel?.text = model[indexPath.row].subTitle
        }
        return cell
    }
}
