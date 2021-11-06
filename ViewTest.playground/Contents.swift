//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport








class MyTextField:UITextField {
    
    override func deleteBackward() {
        super.deleteBackward()
        print(" delete back ward called")
    }
    
}

class MyViewController : UIViewController,UITextFieldDelegate {
    
    lazy var codeView: UITextField = {
        return createCodeField()
    }()
    
    lazy var button: UIButton = {
        let bt = UIButton.init(type: .custom)
        bt.setTitle("按钮-normal", for: .normal)
        bt.setTitle("按钮-被选中", for: .selected)
        bt.setTitleColor(UIColor.blue, for: .normal)
        bt.setTitleColor(UIColor.red, for: .selected)
        bt.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: .touchUpInside)
        return bt
    }()
    
    
    private func createCodeField() -> MyTextField {
        let field = MyTextField.init()
        field.textColor = .black
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.delegate = self
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        
        return field
    }
    
    
    
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 2010, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(codeView)
        codeView.frame = CGRect.init(x: 30, y: 50, width: 50, height: 55)
        view.addSubview(button)
        button.frame = CGRect.init(x: 30, y: 120, width: 100, height: 30)
        
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("textfield.text is \(textField.text),range is \(range),string is \(string)")
        var newText = textField.text
        if let currentText = textField.text, let strRang = Range<String.Index>.init(range, in: currentText) {
            newText?.replaceSubrange(strRang, with: string)
            print("rang in textfield is \(strRang),newText is \(newText)")
        }
            
        if let chars = string.cString(using: .utf8){
            var char = chars[0]
            let strCmpCode = strcmp(&char, "\\b")
            print("string.count \(string.count), chars is \(chars),strCmpCode is \(strCmpCode)")
            
            if strCmpCode == -92  {
                print("输入了倒退按键")
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing ")
    }
    
    var inputValue = ""
    @objc func buttonIsTapped(sender:UIButton) {
        if inputValue.count < 10 {
            inputValue += "1"
        }else {
            inputValue = ""
        }
        codeView.becomeFirstResponder()
    }
    
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController.init()
