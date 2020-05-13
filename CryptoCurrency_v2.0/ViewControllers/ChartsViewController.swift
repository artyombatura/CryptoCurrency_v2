//
//  ChartsViewController.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/13/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
    
    //MARK: - Variables
    public var coin: Coin!
    private var chartDataArray: [ChartData] = [ChartData]()

    //MARK: - Outlets
    @IBOutlet weak var firstChart: LineChartView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetting()
        fetchData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "exchangeSymbol"), style: .plain, target: self, action: #selector(goToExchangeScreen))
    }
    
    //MARK: - Actions
    @objc private func goToExchangeScreen() {
        let exchangeScreen = ExchangeViewController.storyboardInstance
        exchangeScreen.coinToExchange = coin
        navigationController?.present(exchangeScreen, animated: true, completion: nil)
    }


}

//MARK: - Storyboard Instance
extension ChartsViewController {
    static unowned var storyboardInstance: ChartsViewController {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController() as! ChartsViewController
    }
}

//MARK: - UI
extension ChartsViewController {
    func uiSetting() {
        setChartView()
    }
}

//MARK: - Creating test chart dataset
extension ChartsViewController {
    
    private func setChartView() {
        firstChart.scaleYEnabled = false
        firstChart.scaleXEnabled = false
        firstChart.xAxis.enabled = false
        firstChart.rightAxis.enabled = false
        firstChart.drawGridBackgroundEnabled = false
        
    }
    
    private func setChartDataset() {
    
        var lineChartEntry = [ChartDataEntry]()
        
        if self.chartDataArray.count == 0 {
            lineChartEntry.append(ChartDataEntry())
        } else {
            for i in 0..<self.chartDataArray.count {
                        let entry = ChartDataEntry()
                        entry.x = chartDataArray[i].time
                        entry.y = chartDataArray[i].value
                
                        lineChartEntry.append(entry)
            }
        }
        
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Daily chart")

        line1.circleColors = [mainBlueColor as NSUIColor]
        line1.circleHoleColor = mainBlueColor as NSUIColor
        line1.circleRadius = 0.0
        line1.lineWidth = 1.0
        line1.colors = [mainBlueColor as NSUIColor]
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        firstChart.data = data
        firstChart.notifyDataSetChanged()
    }
}

//MARK: - Data fetch
extension ChartsViewController {
    private func fetchData() {
        var tsym = "USD"
        if let tsymUD = UserDefaults.standard.value(forKey: getInternationalCurrencyCode) as? String {
            tsym = tsymUD
        }
        let networkManager = NetworkManager.GetChartData(tsym: tsym, fsym: coin.shortName)
        networkManager.createNetworkSession { (json) in
            self.chartDataArray = ChartData.getDataArray(fromJSON: json)
//            print(self.chartDataArray)
            self.setChartDataset()
        }
    }
}
