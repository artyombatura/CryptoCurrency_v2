//
//  ExchangeViewController.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/13/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var parentBackgroundView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    //MARK: - Variables
    public var coinToExchange: Coin!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSetting()
        
    }
    

}

//MARK: - Storyboard Instance
extension ExchangeViewController {
    static unowned var storyboardInstance: ExchangeViewController {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController() as! ExchangeViewController
    }
}

//MARK: - UI
extension ExchangeViewController {
    private func uiSetting() {
        parentBackgroundView.layer.masksToBounds = false
        parentBackgroundView.layer.shadowColor = UIColor.black.cgColor
        parentBackgroundView.layer.shadowOpacity = 0.4
        parentBackgroundView.layer.shadowOffset = .zero
        parentBackgroundView.layer.shadowRadius = 2
        parentBackgroundView.layer.shouldRasterize = true
        
        fromTextField.delegate = self
        toTextField.delegate = self
        
        fromTextField.tag = 111
        toTextField.tag = 222
        
        fromTextField.placeholder = coinToExchange.shortName
        if let tsym = UserDefaults.standard.value(forKey: getInternationalCurrencyCode) as? String {
            toTextField.placeholder = tsym
        }
        
        fromTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        toTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

//MARK: - TFDelegate
extension ExchangeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fromTextField.text = ""
        toTextField.text = ""
    }
    
    //Custom func: tracking tf changed
    @objc private func textFieldDidChange(_ sender: UITextField) {
        if sender.tag == fromTextField.tag {
            if let from = fromTextField.text {
                if let fromAsDouble = Double(from) {
                    let result = fromAsDouble * coinToExchange.priceValue
                    toTextField.text = String(result)
                }
            }
        } else if sender.tag == toTextField.tag {
            if let from = toTextField.text {
                if let fromAsDouble = Double(from) {
                    let result = fromAsDouble / coinToExchange.priceValue
                    fromTextField.text = String(result)
                }
            }
        }
    }
}
