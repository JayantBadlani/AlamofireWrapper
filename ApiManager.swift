//
//  ApiManager.swift
//  Encro Chat
//
//  Created by Jayant on 23/02/23.
//


import Foundation
import Alamofire

class ApiManager {
    
    static let shared = ApiManager()
    private let kBaseURL = "your_base_url"
    
    private init() {}
    
    func apiCallWith<T: Codable>(apiEndPoint: String, method: HTTPMethod, queryParam: Parameters? = nil, param: Parameters? = nil, extraHeaders: HTTPHeaders? = nil, typeOf: T.Type, completion: @escaping (_ success: Bool, _ response: T?, _ msg: String) -> Void) {
        
        var url = "\(kBaseURL)\(apiEndPoint)"
        
        if let query = queryParam, let queryStr = ApiManager.stringFromHttpParameters(data: query) {
            url = url + "?" + queryStr
        }
        
        let token = UserDefaults.standard.string(forKey: "kToken") ?? ""
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        #if DEBUG
        headers["Current-Url"] = "sandbox"
        #else
        headers["Current-Url"] = "production"
        #endif
        
        extraHeaders?.forEach({ headers[$0.key] = $0.value })
        
        let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
        
        AF.request(url, method: method, parameters: param, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ApiResponse<T>.self) { (response) in
                
                print("API URL: \(url)")
                print("Headers: \(headers)")
                print("Method: \(method)")
                if let request = response.request, method == .get {
                    print("Request: \(request)")
                } else {
                    print("Parameters: \(param ?? [:])")
                }
                
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response: \(jsonString)")
                }
                
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.code == 200 {
                        completion(true, apiResponse.data, apiResponse.msg ?? "")
                    } else {
                        completion(false, nil, apiResponse.msg ?? "Oops, something went wrong.")
                    }
                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        UserDefaults.standard.removeObject(forKey: "kToken")
                        UserDefaults.standard.synchronize()
                        UIApplication.shared.delegate?.performSelector(onMainThread: #selector(AppDelegate.logout), with: nil, waitUntilDone: false)
                    }
                    completion(false, nil, error.localizedDescription)
                }
            }
    }
    
    static func stringFromHttpParameters(data: Parameters?) -> String? {
        guard let parameters = data else { return nil }
        var parametersString = ""
        for (key, value) in parameters {
            parametersString += "\(key)=\(value)&"
        }
        parametersString = String(parametersString.dropLast())
        return parametersString
    }
}

struct ApiResponse<T: Codable>: Codable {
    let code: Int
    let msg: String?
    let data: T?
}
