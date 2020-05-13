//
//  TSYMPickerViewController.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/12/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import UIKit

class TSYMPickerViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tsymTableView: UITableView!
    var settingsVCDelegate: SettingsViewControllerDelegate!
    
    //MARK: - Variables
    private var tsyms: [String] = ["USD", "EUR", "RUB", "GBP", "AUD", "CAD", "MYR", "NZD", "JPY", "CNY"]
        //[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tsymTableView.delegate = self
        tsymTableView.dataSource = self
        tsymTableView.tableFooterView = UIView(frame: .zero)
        
//        fetchInternationalCurrenciesCodes()
    }
    

}

//MARK: - Storyboard Instance
extension TSYMPickerViewController {
    static unowned var storyboardInstance: TSYMPickerViewController {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController() as! TSYMPickerViewController
    }
}

/*
//MARK: - Fetch international currencies codes
extension TSYMPickerViewController {
    private func fetchInternationalCurrenciesCodes() {
        let networkManager: NetworkManager = NetworkManager.GetNationalCurrencyCodes
        var tsyms = [String]()
        networkManager.createNetworkSession { (json) in
            guard let dict = json[0].dictionaryObject as? [String:String]
            else { return }
            
            for (key, _) in dict {
                tsyms.append(key)
            }
            
            self.tsyms = tsyms
            self.tsymTableView.reloadData()
        }
    }
}
*/
 
//MARK: - TableViewDelegate & DataSource
extension TSYMPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tsyms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tsymTableView.dequeueReusableCell(withIdentifier: TSYM_CELL_IDENTIFIER, for: indexPath) as? TSYMCell else { return UITableViewCell() }
        cell.tsymName.text = tsyms[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tsyms.isEmpty {
            if tsyms[indexPath.row] != "" {
                let userdefaults = UserDefaults.standard
                userdefaults.set(tsyms[indexPath.row] as Any, forKey: getInternationalCurrencyCode)
                self.settingsVCDelegate.controllerWillAppearAfterDismiss()
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
