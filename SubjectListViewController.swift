//
//  SubjectListViewController.swift
//  Memorize
//
//  Created by admin on 20/3/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import UIKit

class SubjectListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subjectTable.delegate = self
        subjectTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner.startAnimating()
        LocalMemory.getSubjectList()
        self.subjectList = LocalMemory.subjectList!
        spinner.stopAnimating()
    }

    var subjectList:[String] = [] {
        didSet {
            self.spinner.startAnimating()
            self.subjectTable.reloadData()
            LocalMemory.subjectList = self.subjectList
            LocalMemory.saveSubjectList()
            self.spinner.stopAnimating()
        }
    }
    @IBOutlet weak var subjectTable: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    @IBAction func addSubject(_ sender: UIBarButtonItem) {
        let addSubjectWindow = UIAlertController(title: "Add Subject", message: "Enter subject name.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "add", style: .default) { (_) in
            let subject = addSubjectWindow.textFields?.first?.text
            if subject != nil && subject! != "" {
                for sub in self.subjectList {
                    if sub == subject {
                        let alert = UIAlertController(title: "Error", message: "Another subject with the name \'\(subject!)\' already exists.", preferredStyle: .alert)
                        let close = UIAlertAction(title: "close", style: .cancel, handler: nil)
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                self.subjectList.append(subject!)
            }
        }
        addSubjectWindow.addAction(cancel)
        addSubjectWindow.addTextField { (name) in
            name.placeholder = "Subject"
        }
        addSubjectWindow.addAction(add)
        present(addSubjectWindow, animated: true, completion: nil)
    }
    
    func confirmationToDelete(_ subject:String) {
        let deleteSubjectAlert = UIAlertController(title: "Delete Subject",
                                                   message: "By removing the subject, all the resources owned by this subject will be deleted permanently.\n\n Confirm to delete subject '\(subject)'?",
                                                   preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "delete", style: .destructive) { (_) in
            self.spinner.startAnimating()
            deleteSubject(withName: subject)
            for index in self.subjectList.indices {
                if self.subjectList[index] == subject {
                    self.subjectList.remove(at: index)
                    break
                }
            }
        }
        deleteSubjectAlert.addAction(cancel)
        deleteSubjectAlert.addAction(delete)
        present(deleteSubjectAlert, animated: true, completion: nil)
    }
    
    //MARK: - table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subject", for: indexPath)
        cell.textLabel?.text = subjectList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmationToDelete(LocalMemory.subjectList![indexPath.row])
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let topicViewController = segue.destination as? TopicsViewController
        let cell = sender as? UITableViewCell
        let subject = cell?.textLabel?.text
        topicViewController?.subject = subject!
    }
    

}
