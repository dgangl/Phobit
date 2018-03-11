//
//  DatePickerViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 17.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datepicker: UIDatePicker!
    
    
    // has to be set...
    var delegate: EditingProtocol?
    var indexPath: IndexPath?
    var date: String?
    
    @IBOutlet weak var pickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let date = date {
            let df = DateFormatter()
            df.dateFormat = "d.M.yyyy"
            
            datepicker.date = df.date(from: date)!
        }
        
        
        let tapToExit = UITapGestureRecognizer.init(target: self, action: #selector(cancelButton(_:)))
        let backView = UIView.init(frame: self.view.frame)
        self.view.addSubview(backView)
        
        backView.addGestureRecognizer(tapToExit)
        
        view.bringSubview(toFront: pickerView)
        
        pickerView.center = self.view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy"
        
        delegate?.userDidEdit(inIndexPath: indexPath!, changedText: dateFormatter.string(from: datepicker.date))
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
}
