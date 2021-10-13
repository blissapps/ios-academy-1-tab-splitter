//
//  Currency.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 07/10/2021.
//

import Foundation

import Moya

struct LatestDto: Decodable{
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Decimal]
}

typealias ApiClientResultCallback = (LatestDto) -> Void

class ApiClient {
    let provider: MoyaProvider<Currency>
    
    init() {
        provider = MoyaProvider<Currency>()
    }
    
    func getLatest(completion: @escaping ApiClientResultCallback){
        provider.request(.latest, completion:  { result in
            let response = try? result.get()
            guard let latest = try? response?.map(LatestDto.self) else{ return }
            completion(latest)
        })
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
