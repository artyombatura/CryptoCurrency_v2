//
//  CurrenciesViewController.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/9/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import UIKit
import SDWebImage

protocol CurrenciesViewControllerDelegate {
    func updateCurrenciesAfterDismiss()
}

class CurrenciesViewController: UIViewController, CurrenciesViewControllerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var currenciesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables
    private var coins: [Coin] = [Coin]()
    private var pageToDownload: Int = 0
    let userdefaults = UserDefaults.standard

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "CryptoCurrency"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsSymbol")!, style: .plain, target: self, action: #selector(openSettingsScreen))
        navigationController?.navigationBar.tintColor = UIColor.systemPurple

        currenciesTableView.delegate = self
        currenciesTableView.dataSource = self
        currenciesTableView.tableFooterView = UIView(frame: .zero)
    
        fetchCoins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

    //MARK: - Actions
    @objc func openSettingsScreen() {
        self.coins = [Coin]()
        self.pageToDownload = 0
        let settingsVC = SettingsViewController.storyboardInstance
        settingsVC.currenciesVCDelegate = self
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    //MARK: - CurrenciesViewControllerDelegate
    func updateCurrenciesAfterDismiss() {
        fetchCoins()
    }
}

//MARK: - Storyboard Instance
extension CurrenciesViewController {
    static unowned var storyboardInstance: CurrenciesViewController {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController() as! CurrenciesViewController
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension CurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = coins.count
        if count == 0 {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            currenciesTableView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            currenciesTableView.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = currenciesTableView.dequeueReusableCell(withIdentifier: CURRENCY_CELL_IDENTIFIER, for: indexPath) as? CurrencyCell else { return UITableViewCell() }
        cell.backgroundGradientView.backgroundColor = cellTopGradientColor
        cell.shortNameLabel.text = coins[indexPath.row].shortName
        cell.fullNameLabel.text = coins[indexPath.row].fullName
        cell.priceLabel.text = coins[indexPath.row].price
    
        cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.height / 2
        cell.logoImageView.sd_setImage(with: URL(string: baseUrl + coins[indexPath.row].imgURL), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currenciesTableView.deselectRow(at: indexPath, animated: true)
        
        let chartsVC = ChartsViewController.storyboardInstance
        chartsVC.coin = coins[indexPath.row]
        navigationController?.pushViewController(chartsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == Int(self.coins.count / 2) {
            pageToDownload += 1
            for coin in self.coins {
                print(coin.imgURL)
            }
            self.fetchCoins()
        }
    }
}

//MARK: - FetchCoins
extension CurrenciesViewController {
    private func fetchCoins() {
        var tsym = "USD"
        if let tsymFromUserConfig = userdefaults.value(forKey: getInternationalCurrencyCode) as? String {
            tsym = tsymFromUserConfig
        }
        let networkSession = NetworkManager.GetAllCurrencies(tsym: tsym, page: pageToDownload, limit: 10)
        networkSession.createNetworkSession { (json) in
            let coins = Coin.getAllCoinsArray(fromJSON: json)
            coins.forEach { (coin) in
                self.coins.append(coin)
            }
            self.currenciesTableView.reloadData()
        }
    }
}
