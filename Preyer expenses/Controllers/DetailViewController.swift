//
//  DetailViewController.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift


class DetailViewController:  FormViewController {

    let realm = try! Realm()

    
    func configureView() {

     
        form +++ Section("Trip Details")
            <<< PickerInlineRow <String>() {
                $0.title = "Payor:"
                let payor = self.realm.object(ofType: Partner.self, forPrimaryKey: self.detailItem?.payor)
                $0.value = payor?.name ?? ""
                let optionArray = Array(realm.objects(Partner.self).filter("payor = true").sorted(byKeyPath: "name").map{ "\($0.name)" })
                $0.options = optionArray
                $0.onChange({ (row) in
                    if row.value != nil {
                        try! self.realm.write {
                            print ("RowValue: \(row.value!)")
                            let chosenPayor = self.realm.objects(Partner.self).filter("name = '\(row.value!)'").first
                            print ("payor: \(String(describing: chosenPayor))")
                            self.detailItem?.payor = (chosenPayor?.id)!
                            print ("detailItem: \(String(describing: self.detailItem))")
                            self.realm.add(self.detailItem!, update: true)
                        }
                    }
                })
            }
            <<< PickerInlineRow <String>() {
                $0.title = "Country:"
                let country = self.realm.object(ofType: Country.self, forPrimaryKey: self.detailItem?.country)
               
                $0.value = country?.name
                let optionArray = Array(realm.objects(Country.self).sorted(byKeyPath: "name").map{ "\($0.name)" })
                $0.options = optionArray
                $0.onChange({ (row) in
                     if row.value != nil {
                        try! self.realm.write {
                            print ("RowValue: \(row.value!)")
                            let chosenCountry = self.realm.objects(Country.self).filter("name = '\(row.value!)'").first
                            print ("Country: \(String(describing: chosenCountry))")
                            self.detailItem?.country = (chosenCountry?.id)!
                            print ("detailItem: \(String(describing: self.detailItem))")
                            self.realm.add(self.detailItem!, update: true)
                        }
                    }
                })
            }
            <<< TextRow(){
                $0.title = "infoText:"
                $0.placeholder =  "Enter text here"
                $0.value = self.detailItem?.infoText
                $0.onChange({ (row) in
                    if row.value != nil {
                        try! self.realm.write {
                            self.detailItem?.infoText = row.value!
                            self.realm.add(self.detailItem!, update: true)
                        }
                    }
                })
                
            }
            
            <<< TextAreaRow() {
                $0.title = "Reason:"
                $0.placeholder =  "Enter text here"
                $0.value = self.detailItem?.reason 
                $0.onChange({ (row) in
                     if row.value != nil {
                        try! self.realm.write {
                            self.detailItem?.reason = row.value!
                            self.realm.add(self.detailItem!, update: true)
                        }
                    }
                })
            }

            +++ Section("Dates")
            <<< DateTimeRow() {
                $0.title = "Beginning:"
                
                $0.value = self.detailItem?.beginning ?? Date(timeIntervalSinceReferenceDate: 0)
                $0.onChange { [unowned self] row in
                    if let date = row.value {
                          try! self.realm.write {
                            self.detailItem?.beginning = date
                            self.realm.add(self.self.detailItem!, update: true)
                        }
                    }
                }
            }
            <<< DateTimeRow(){
                $0.title = "Ending:"
                $0.value = self.detailItem?.ending ?? Date(timeIntervalSinceReferenceDate: 0)
                $0.onChange { [unowned self] row in
                    if let date = row.value {
                        try! self.realm.write {
                            self.detailItem?.ending = date
                           self.realm.add(self.self.detailItem!, update: true)
                        }
                    }
                }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Trip? {
        didSet {
            // Update the view.
          //  configureView()
        }
    }


}

