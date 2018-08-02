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
        // Update the user interface for the detail item.
        //if let detail = detailItem {
         //   if let label = detailDescriptionLabel {
         //       label.text = detail.infoText
         //   }
         //   reasonLabel?.text! = detail.reason
          //    }
     
        form +++ Section("Trip Details")
            <<< PickerInlineRow <String>() {
                $0.title = "Payor:"
     //           if let payorID = self.detailItem?.payor {
                    
     //               let payor : Partner = payors.lazy.filter( {return $0 == payorID }).first!
     //               $0.value = "\(payor.name)"
     //             }
          //      let optionArray =
          //          Array(payors.sorted().map { "\( $0.name)" })
                //debugPrint(optionArray)
            //    $0.options = optionArray

            }
            <<< PickerInlineRow <String>() {
                $0.title = "Country:"
         //       if let cntID = self.detailItem?.country  {
             //       let cnty : Country = countries.lazy.filter( {return $0 == cntID }).first!
              //      $0.value = "\(cnty.name)"
          //       }
           //     let optionArray =
           //         Array(countries.sorted().map { "\($0)" })
                //debugPrint(optionArray)
        //        $0.options = optionArray
            }
            <<< TextRow(){
                $0.title = "infoText:"
                $0.placeholder =  "Enter text here"
                $0.value = self.detailItem?.infoText
                $0.onChange({ (row) in
                    let rlm = try! Realm()
                    if row.value != nil {
                        try! rlm.write {
                            self.detailItem?.infoText = row.value!
                            rlm.add(self.self.detailItem!, update: true)
                        }
                    }
                })
                
            }
            
            <<< TextAreaRow() {
                $0.title = "Reason:"
                $0.placeholder =  "Enter text here"
                $0.value = self.detailItem?.reason 
                $0.onChange({ (row) in
                    let rlm = try! Realm()
                    if row.value != nil {
                        try! rlm.write {
                            self.detailItem?.reason = row.value!
                            rlm.add(self.self.detailItem!, update: true)
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
                         let rlm = try! Realm()
                         try! rlm.write {
                            self.detailItem?.beginning = date
                            rlm.add(self.self.detailItem!, update: true)
                        }
                    }
                }
            }
            <<< DateTimeRow(){
                $0.title = "Ending:"
                $0.value = self.detailItem?.ending ?? Date(timeIntervalSinceReferenceDate: 0)
                $0.onChange { [unowned self] row in
                    if let date = row.value {
                        let rlm = try! Realm()
                        try! rlm.write {
                            self.detailItem?.ending = date
                           rlm.add(self.self.detailItem!, update: true)
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

