//
//  Currency.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 07/10/2021.
//

import Foundation

import Moya

class ApiClient {
    let provider: MoyaProvider<Currency>
    
    init() {
        provider = MoyaProvider<Currency>()
    }
    
    func getLatest() {
        provider.request(.latest) { result in
            let response = try? result.get()
            print(response)
        }
    }
}

public enum Currency {
  // 1
  static public let privateKey = "372bf37d48588024455a61ad71f296a5"
    case latest
}
/*
 latest? access_key = YOUR_ACCESS_KEY
     & base = GBP
     & symbols = USD,AUD,CAD,PLN,MXN
*/

extension Currency: TargetType {
  // 1
  public var baseURL: URL {
    return URL(string: "http://api.exchangeratesapi.io/v1/")!
  }

  // 2
  public var path: String {
    switch self {
    case .latest: return "/latest"
    }
  }

  // 3
  public var method: Moya.Method {
    switch self {
    case .latest: return .get
    }
  }

  // 4
  public var sampleData: Data {
    return Data()
  }

  // 5
  public var task: Task {
    return .requestParameters(parameters: ["access_key":Currency.privateKey], encoding: URLEncoding.default)
  }

  // 6
  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  // 7
  public var validationType: ValidationType {
    return .successCodes
  }
}
