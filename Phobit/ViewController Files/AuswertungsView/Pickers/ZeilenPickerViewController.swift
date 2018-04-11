import UIKit

class ZeilenPickerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var label = "Bitte gib den ... ein"
    
    // has to be set...
    var delegate: SpaltenSelectionProtocol?
    var matrix: (Int, Int)?
    
    @IBOutlet weak var pickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap anywhere to exit...
        let tapToExit = UITapGestureRecognizer.init(target: self, action: #selector(cancelSheet(_:)))
        let backView = UIView.init(frame: self.view.frame)
        self.view.addSubview(backView)
        
        backView.addGestureRecognizer(tapToExit)
        
        view.bringSubview(toFront: pickerView)
        informationLabel.text = label
        
        
        
        
        
        
        
        pickerView.center = CGPoint.init(x: self.view.frame.midX, y: self.view.frame.height/2.5)
        
        
        if matrix == nil {
            // at least it does not die...
            self.matrix = (0, 1)
        }
        
        
        textField.delegate = self
        
        // setting up the keyboard type
        if(matrix?.1 == 0){
            textField.keyboardType = .asciiCapableNumberPad
            textField.inputAccessoryView = CustomToolbar.getAuswertungsToolbar(action: #selector(callDelegate), target: self)
            textField.autocorrectionType = .no
            
        }else{
        textField.keyboardType = .decimalPad
        textField.inputAccessoryView = CustomToolbar.getAuswertungsToolbar(action: #selector(callDelegate), target: self)
        textField.autocorrectionType = .no
        }
        
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // making the textfield selected...
        self.textField.becomeFirstResponder()
    }
    
    
    @objc private func callDelegate() {
        let text = textField.text!
        delegate?.finishedEditing(forMatrix: matrix!, text: text)
        
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

