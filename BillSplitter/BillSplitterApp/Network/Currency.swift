//
//  Currency.swift
//  BillSplitterApp
//
//  Created by Filipe Santo on 07/10/2021.
//

import Foundation

import Moya
import AmountValue
import BillSplitter

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
  static public let privateKey = "372bf37d48588024455a61ad71f296a5"
    case latest
}

extension Currency: TargetType {
  public var baseURL: URL {
    return URL(string: "http://api.exchangeratesapi.io/v1/")!
  }

  public var path: String {
    switch self {
    case .latest: return "/latest"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .latest: return .get
    }
  }

  public var sampleData: Data {
    return Data()
  }

  public var task: Task {
    return .requestParameters(parameters: ["access_key":Currency.privateKey], encoding: URLEncoding.default)
  }

  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}
