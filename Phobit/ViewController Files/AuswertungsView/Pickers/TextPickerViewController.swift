//
//  TextPickerViewController.swift
//  Phobit
//
//  Created by 73 on 17.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit

class TextPickerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var label = "Bitte gib den ... ein"
    
    var textFieldString : String = ""
    
    // has to be set...
    var delegate: EditingProtocol?
    var indexPath: IndexPath?
    
    @IBOutlet weak var pickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.backgroundColor = UIColor.clear
        textField.isHidden = true
        informationLabel.isHidden = true


        // tap anywhere to exit...
        let tapToExit = UITapGestureRecognizer.init(target: self, action: #selector(cancelSheet(_:)))
        let backView = UIView.init(frame: self.view.frame)
        self.view.addSubview(backView)
        
        backView.addGestureRecognizer(tapToExit)
        
        view.bringSubview(toFront: pickerView)
        informationLabel.text = label
        
        /*
        let range = NSRange.init(location: 0, length: textFieldString.count)
        textField.setMarkedText(textFieldString, selectedRange: range)
        */
        
        pickerView.center = CGPoint.init(x: self.view.frame.midX, y: self.view.frame.height/2.5)
        

        if indexPath == nil {
            // at least it does not die...
            self.indexPath = IndexPath.init(row: 0, section: 0)
        }
        
        
        textField.delegate = self
        
        // setting up the keyboard type
        switch indexPath!.section {
        case 0:
            textField.keyboardType = .default
        case 3:
            textField.keyboardType = .asciiCapableNumberPad
           
            // setting up the toolbar...
            textField.inputAccessoryView = CustomToolbar.getAuswertungsToolbar(action: #selector(callDelegate), target: self)
            textField.autocorrectionType = .no
        case 4:
            textField.keyboardType = .default
        default:
            textField.keyboardType = .default
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // making the textfield selected...
        self.textField.becomeFirstResponder()
        
        // checking if it isn't the template
        if textFieldString == "Bitte Rechnungsersteller eingeben." {
            textFieldString = ""
        }
        
        textField.text = textFieldString
        
        // selecting the text...
        textField.selectAll(nil)
        
        UIView.animate(withDuration: 0.175){
            self.pickerView.backgroundColor = UIColor.white
            self.textField.isHidden = false
            self.informationLabel.isHidden = false
        }
    }
    
    
    @objc private func callDelegate() {
        // before we get to the delegate we have to format correctly...
        let text = textField.text!
        
        
        // right no we don't have anything to be formatted
//        switch indexPath?.section {
////        case 0:
////        nothing to do here, we dont format the text
//        case 3:
//
//        }

        delegate?.userDidEdit(inIndexPath: indexPath!, changedText: text)
        
        self.dismiss(animated: false, completion: nil)
    }

    
    @IBAction func cancelSheet(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func cancel() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // only critical if we would want to add decimal numbers...
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        callDelegate()
        return true
    }
}
