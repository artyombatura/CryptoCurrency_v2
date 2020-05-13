//
//  SettingsViewController.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/11/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SettingsViewControllerDelegate {
    func controllerWillAppearAfterDismiss()
}

class SettingsViewController: UIViewController, SettingsViewControllerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var settingsTableView: UITableView!
    
    //MARK: - Variables
    var settingsCells: [String] = ["Выбор национальной валюты"]
    let userdefaults = UserDefaults.standard
    var currenciesVCDelegate: CurrenciesViewControllerDelegate!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        settingsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        currenciesVCDelegate.updateCurrenciesAfterDismiss()
    }
    
    //MARK: - Delegate actions
    func controllerWillAppearAfterDismiss() {
        settingsTableView.reloadData()
    }
    
}

//MARK: - Storyboard Instance
extension SettingsViewController {
    static unowned var storyboardInstance: SettingsViewController {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController() as! SettingsViewController
    }
}

//MARK: - TableViewDelegate & DataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingsTableView.dequeueReusableCell(withIdentifier: SETTING_CELL_IDENTIFIER, for: indexPath) as? SettingCell else { return UITableViewCell() }
        cell.settingNameLabel.text = settingsCells[indexPath.row]
        if let tsym = userdefaults.value(forKey: getInternationalCurrencyCode) as? String {
            cell.tsymLabel.text = tsym
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsTableView.deselectRow(at: indexPath, animated: true)
        let nextVC = TSYMPickerViewController.storyboardInstance
        nextVC.settingsVCDelegate = self
        navigationController?.present(nextVC, animated: true, completion: nil)
    }
}
