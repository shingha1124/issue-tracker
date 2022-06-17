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
    
    func loadImage(url: URL) -> Single<UIImage> {
        Single.create { observer in
            let imageName = url.lastPathComponent
            
            if let cacheImage = self.imageCache.object(forKey: imageName as NSString) {
                observer(.success(cacheImage))
                return Disposables.create { }
            }

            guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                return Disposables.create { }
            }

            let destination = cachesDirectory.appendingPathComponent(imageName)
            
            if FileManager.default.fileExists(atPath: destination.path),
               let image = UIImage(contentsOfFile: destination.path) {
                self.imageCache.setObject(image, forKey: imageName as NSString)
                observer(.success(image))
                return Disposables.create { }
            }
            
            let task = URLSession.shared.downloadTask(with: url) { url, _, _ in
                guard let url = url else { return }
                try? FileManager.default.copyItem(at: url, to: destination)
                
                guard let image = UIImage(contentsOfFile: destination.path) else {
                    return
                }
                self.imageCache.setObject(image, forKey: imageName as NSString)
                observer(.success(image))
            }
            task.resume()
            
            return Disposables.create { }
        }
    }
}
