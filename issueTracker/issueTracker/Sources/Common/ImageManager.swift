//
//  ImageManager.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation
import RxSwift
import UIKit

class ImageManager {
    private let imageCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    
    func loadImage(url: URL) -> Single<UIImage> {
        Single.create { [weak self] observer in
            let imageName = url.lastPathComponent
            
            guard let cachesDirectory = self?.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                return Disposables.create { }
            }

            let fileUrl = cachesDirectory.appendingPathComponent(imageName)
            
            if let cacheImage = self?.checkCache(name: imageName) {
                observer(.success(cacheImage))
                return Disposables.create { }
            }
            
            if let fileImage = self?.checkFile(fileUrl) {
                self?.imageCache.setObject(fileImage, forKey: imageName as NSString)
                observer(.success(fileImage))
                return Disposables.create { }
            }
            
            return URLSession.shared.rx.download(with: url)
                .compactMap { result -> UIImage? in
                    guard let url = result.url else {
                        return nil
                    }
                    try? FileManager.default.copyItem(at: url, to: fileUrl)

                    return UIImage(contentsOfFile: fileUrl.path)
                }
                .bind(onNext: {
                    observer(.success($0))
                })
        }
    }
    
    private func checkCache(name: String) -> UIImage? {
        self.imageCache.object(forKey: name as NSString)
    }
    
    private func checkFile(_ url: URL) -> UIImage? {
        if fileManager.fileExists(atPath: url.path),
           let image = UIImage(contentsOfFile: url.path) {
            return image
        }
        return nil
    }
}
