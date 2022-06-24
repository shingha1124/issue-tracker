//
//  Rx+URLSession+Extension.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/17.
//

import Foundation
import RxSwift

extension Reactive where Base: URLSession {
    func download(with url: URL) -> Observable<(url: URL?, response: URLResponse?, error: Error?)> {
        Observable.create { observer in
            let task = base.downloadTask(with: url) { url, response, error in
                observer.on(.next((url, response, error)))
                observer.on(.completed)
            }
            task.resume()
            
            return Disposables.create(with: task.cancel)
        }
    }
}
