//
//  NetworkManager.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/10/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public let baseUrl = "https://cryptocompare.com"
public let minApiBaseUrl = "https://min-api.cryptocompare.com/data"
public let internationalCurrencyCodesAPI = "https://openexchangerates.org/api/currencies.json"
private let apiKey = "247f4279d26a7e83c5256cc4a26f624006a0c8f5a220b6c0afbd2f0e09860c4f"

enum NetworkManager {
    
    case GetAllCurrencies(tsym: String, page: Int, limit: Int)
    case GetNationalCurrencyCodes
    case GetChartData(tsym: String, fsym: String)
    
    private var fullUrl: URL? {
        get {
            switch self {
            case .GetAllCurrencies(_, _, _):
                if let url = URL(string: minApiBaseUrl + "/top/totalvolfull") {
                    return url
                }
            case .GetNationalCurrencyCodes:
                return URL(string: internationalCurrencyCodesAPI)
            case .GetChartData(_, _):
                return URL(string: minApiBaseUrl + "/v2/histoday")
            }
            
            return nil
        }
    }
    
    private var headers: HTTPHeaders {
        get {
            switch self {
            case .GetAllCurrencies(_, _, _):
                return HTTPHeaders(["apiKey":apiKey])
            case .GetNationalCurrencyCodes:
                return HTTPHeaders([:])
            case .GetChartData(_, _):
                return HTTPHeaders([:])
            }
        }
    }
    
    private var parameters: Parameters {
        switch self {
        case .GetAllCurrencies(let tsym, let page, let limit):
            return ["tsym": tsym, "limit": limit, "page": page]
        case .GetNationalCurrencyCodes:
            return [:]
        case .GetChartData(let tsym, let fsym):
            return ["tsym": tsym, "fsym": fsym, "limit": "100"]
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .GetAllCurrencies(_, _, _):
            return .get
        case .GetNationalCurrencyCodes:
            return .get
        case .GetChartData(_, _):
            return .get
        }
    }
    
    public func createNetworkSession(completion: @escaping (JSON)->()) {
        guard let fullUrlUnwrapped = fullUrl else { return }
        
        AF.request(fullUrlUnwrapped, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                print("SUCCESS")
                let json = JSON(arrayLiteral: json)
                completion(json)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
}
