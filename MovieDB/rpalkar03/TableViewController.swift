//
//  TableViewController.swift
//  rpalkar03
//
//  Created by Rajesh Palkar on 3/19/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import Foundation
import UIKit
import Contacts


class MyTableViewController: UITableViewController {
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    var contactsFromContacts:[CNContact] = []
    var contactsWithSections = [[CNContact]]()
    var sectionTitles = [String]()
    
 //   var myContacts = [MyContacts]() // Data we will use
    
    func collateConatacts() {
        let collation = UILocalizedIndexedCollation.current()
        
        print("Collation: \(self.contactsFromContacts.count)")
        
        let (arrayContacts, arrayTitles) = collation.partitionObjects(array: self.contactsFromContacts, collationStringSelector: #selector(getter: CNContact.familyName))
        
        self.contactsWithSections = arrayContacts as! [[CNContact]]
        
        self.sectionTitles = arrayTitles
        
        
      /*  for index in 0 ..< self.contactsWithSections.count {
            if self.contactsWithSections[index].count > 0 {
                var contacts = [Person]()
                
                for idx in 0 ..< self.contactsWithSections[index].count{
                    let newPerson = Person(person: self.contactsWithSections[index][idx], isFavorited: false)
                    contacts.append(newPerson)
                }
                
                let newCat = MyContacts(isCollapsed: false, headerTitle: self.sectionTitles[index], contacts: contacts)
                
                self.myContacts.append(newCat)
            }
        }*/
    }
    
    func fetchContacts() {
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed in request access: " , err)
                return
            }
            
            if granted {
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
                        
                        print(contact.givenName, contact.familyName)
                        
                        self.contactsFromContacts.append(contact)
                    })
                    
                    self.collateConatacts()
                }
                catch let err {
                    print("Failed to enumerate contacts: ", err)
                }
            }
            else{
                print("Access denied")
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContacts()
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // add activityIndicatorView to view controller, so viewWillAppear will be called
        self.activityIndicatorView = activityIndicatorView
        
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "cellid")
    }
    
    // called before the view controller's view is about to be added to a view hierarchy and before any animations are configured for showing the view.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        if myContacts.count == 0 {
            activityIndicatorView.startAnimating()
            
            // add delay! after deadline, run the execute closure!
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                self.activityIndicatorView.stopAnimating()
                
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.reloadData()
            })
        }
    }
    
    // Number of Rows per Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myContacts[section].isCollapsed {
            return 0
        }
        
        return myContacts[section].contacts.count
    }
    
    // Table View Cell for Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! MyTableViewCell
        
        let cell = MyTableViewCell(style: .default, reuseIdentifier: "cellid")
        
        cell.link = self
        
        let contact = myContacts[indexPath.section].contacts[indexPath.row]
        let name = contact.person.givenName + " " + contact.person.familyName
        cell.contactName.text = name
        
        
        let firstphone = contact.person.phoneNumbers.first?.value.stringValue
        cell.contactPhone.text = firstphone
        
        cell.favoriteButton.tintColor = contact.isFavorited ? UIColor.red : .lightGray
        
        
        return cell
    }
    
    // Height for each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("MyContact: \(myContacts.count)")
        
        for index in 0 ..< myContacts.count {
            print("Header: \(myContacts[index].headerTitle) Contact count: \(myContacts[index].contacts.count)")
        }
        
        return myContacts.count
        //return contactsWithSections.count
    }
    
    @objc func handleCollapsing(button: UIButton){
        print("Trying to expand and close section...")
        
        let section = button.tag
        
        print("Collapsing Handle \(section)")
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in myContacts[section].contacts.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isCollapsed = myContacts[section].isCollapsed
        myContacts[section].isCollapsed = !isCollapsed
        
        button.setImage(isCollapsed ? #imageLiteral(resourceName: "collapsing") : #imageLiteral(resourceName: "expanding"), for: .normal)
        
        if !isCollapsed {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .yellow
        
        let label = UILabel()
        label.text = myContacts[section].headerTitle
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        let button = UIButton(type: .system)
        button.setImage(myContacts[section].isCollapsed ? #imageLiteral(resourceName: "expanding") : #imageLiteral(resourceName: "collapsing"), for: .normal)
        button.tintColor = .purple
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleCollapsing), for: .touchUpInside)
        
        button.tag = section
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        label.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    //// action set/reset routine for tapping favorite button
    func favoriteHandled(cell: UITableViewCell){
        // retrieve indexPath for the tapped cell
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let contact = myContacts[indexPathTapped.section].contacts[indexPathTapped.row]
        print(contact.person.givenName, contact.person.familyName)
        
        let isFavorited = contact.isFavorited
        
        // update(toggle) favorite flag
        myContacts[indexPathTapped.section].contacts[indexPathTapped.row].isFavorited = !isFavorited
        
        let cell = cell as! MyTableViewCell
        
        // change favorite button color
        cell.favoriteButton.tintColor = isFavorited ? UIColor.lightGray : .red
    }
    
}

extension UILocalizedIndexedCollation {
    //func for partition array in sections
    func partitionObjects(array:[AnyObject], collationStringSelector:Selector) -> ([AnyObject], [String]) {
        
        var unsortedSections = [[AnyObject]]()
        //1. Create a array to hold the data for each section
        for _ in self.sectionTitles {
            unsortedSections.append([]) //appending an empty array
        }
        //2. Put each objects into a section
        for item in array {
            let index:Int = self.section(for: item, collationStringSelector:collationStringSelector)
            unsortedSections[index].append(item)
        }
        
        //print(unsortedSections)
        
        //3. sorting the array of each sections
        var sectionTitles = [String]()
        var sections = [AnyObject]()
        for index in 0 ..< unsortedSections.count {
            if unsortedSections[index].count > 0 {
                sectionTitles.append(self.sectionTitles[index])
                sections.append(self.sortedArray(from: unsortedSections[index], collationStringSelector: collationStringSelector) as AnyObject)
            }
        }
        return (sections, sectionTitles)
    }
}
