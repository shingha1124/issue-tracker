//
//  Provider.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Alamofire
import Foundation
import RxSwift

class Provider<Target: BaseTarget> {
    private static func createRequest(_ target: Target) -> URLRequest? {
        
        var url: URL?
        
        if target.content == .query {
            guard let stringUrl = target.baseURL?.absoluteString else {
                return nil
            }
            let baseUrl = stringUrl + (target.path ?? "")
            var components = URLComponents(string: baseUrl)
            
            let querys = target.parameter?.compactMap { key, value -> URLQueryItem? in
                guard let value = value as? String else {
                    return nil
                }
                return URLQueryItem(name: key, value: value )
            }
            
            components?.queryItems = querys
            url = components?.url
        } else {
            if let path = target.path {
                url = target.baseURL?.appendingPathComponent(path)
            }
        }
        
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = target.method.value
        target.header?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if target.content == .query {
            return request
        }
        
        if target.content == .urlencode {
            if let param = target.parameter {
                let formDataString = param.reduce(into: "") {
                    $0 = $0 + "\($1.key)=\($1.value)&"
                }.dropLast()

                request.httpBody = formDataString.data(using: .utf8, allowLossyConversion: true)
            }
        } else {
            if let param = target.parameter,
               let body = try? JSONSerialization.data(withJSONObject: param, options: .init()) {
                request.httpBody = body
            }
        }
        
        return request
    }
    
    func request(_ target: Target) -> Single<Swift.Result<Response, APIError>> {
        Single.create { observer in
            guard let request = Self.createRequest(target) else {
                let error = APIError.custom(message: "", debugMessage: "Request가 제대로 생성되지 않았습니다.")
                observer(.success(.failure(error)))
                return Disposables.create { AF.session.invalidateAndCancel() }
            }
            
            let dataRequest: DataRequest = AF.request(request)
            
            dataRequest
                .response { dataResponse in
                    switch ( dataResponse.response, dataResponse.data, dataResponse.error) {
                    case let (.some(urlResponse), data, .none):
                        let response = Response(statusCode: urlResponse.statusCode, data: data ?? Data(), request: request, response: urlResponse)
                        observer(.success(.success(response)))
                        
                    case let (.some(urlResponse), _, .some(error)):
                        let response = Response(statusCode: urlResponse.statusCode, data: Data(), request: request, response: urlResponse)
                        let apiError = APIError.underlying(error: error, response: response)
                        observer(.success(.failure(apiError)))
                        
                    case let (_, _, .some(error)):
                        let apiError = APIError.underlying(error: error, response: nil)
                        observer(.success(.failure(apiError)))
                        
                    default:
                        let apiError = APIError.underlying(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil), response: nil)
                        observer(.success(.failure(apiError)))
                    }
                }
            
            return Disposables.create {  }
        }
    }
}
