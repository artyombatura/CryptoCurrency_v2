//
//  Coin.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/10/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Coin {
    var shortName: String = ""
    var fullName: String = ""
    var price: String = ""
    var imgURL: String = ""
    var priceValue: Double = 0.0
    
    init(shortName: String, fullName: String, price: String, imgURL: String, priceValue: Double) {
        self.shortName = shortName
        self.fullName = fullName
        self.price = price
        self.imgURL = imgURL
        self.priceValue = priceValue
    }
    
    init() {
        
    }
    
    static func getAllCoinsArray(fromJSON json: JSON) -> [Coin] {
        var coins = [Coin]()
        let dataArray = json[0]["Data"].array
        print(dataArray)
        if let dataArrayUnwrapped = dataArray {
            for data in dataArrayUnwrapped {
                let coin = Coin()
                if let shortName = data["CoinInfo"]["Name"].string {
                    coin.shortName = shortName
                }
                if let fullName = data["CoinInfo"]["FullName"].string {
                    coin.fullName = fullName
                }
                
                
                if let tsymFromUserConfig = UserDefaults.standard.value(forKey: getInternationalCurrencyCode) as? String {
                    if let price = data["DISPLAY"][tsymFromUserConfig]["PRICE"].string {
                        coin.price = price
                    }
                    
                    if let priceValue = data["RAW"][tsymFromUserConfig]["PRICE"].double {
                        coin.priceValue = priceValue
                    }
                }
                
                if let imageURL = data["CoinInfo"]["ImageUrl"].string {
                    coin.imgURL = imageURL
                }
                
                coins.append(coin)
            }
        }
        
        return coins
    }
}
