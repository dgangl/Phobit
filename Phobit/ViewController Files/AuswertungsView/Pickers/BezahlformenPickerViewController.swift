//
//  BezahlformenPickerViewController.swift
//  Phobit
//
//  Created by Julian Kronlachner on 25.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit

class BezahlformenPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let data = ["Bar", "Bank", "PSK", "Online Bezahlung" ,"Kreditkarte", "Andere"]
    var indexPath: IndexPath?
    var delegate: EditingProtocol?
    var returnTypeBezahlung = ""
    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        
        returnTypeBezahlung = data[0]
        let tapToExit = UITapGestureRecognizer.init(target: self, action: #selector(didExit(_:)))
        let backView = UIView.init(frame: self.view.frame)
        self.view.addSubview(backView)
        
        backView.addGestureRecognizer(tapToExit)
        
        view.bringSubview(toFront: pickerView)
        
        pickerView.center = self.view.center
        

       
    }
    
    @IBAction func didPressDon(_ sender: Any) {
        delegate?.userDidEdit(inIndexPath: indexPath!, changedText: returnTypeBezahlung)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func didExit(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow rowInt: Int, forComponent component: Int) -> String? {
        let string = data[rowInt]
        print(string)
        return string
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        returnTypeBezahlung = data[row]
    }
    
    
    func didChangeValue<Value>(for keyPath: KeyPath<BezahlformenPickerViewController, Value>) {
        
    }
    
    
    
    

}


