//
//  ImageDownloader.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 12.09.2023.
//

import Foundation
import Kingfisher

class ImageDownloader<T> where T: Hashable {
    private let semaphore = DispatchSemaphore(value: 3)
    private let downloadQueue = DispatchQueue.global(qos: .utility)
    
    private var activeDownloads = [T: DownloadTask?]()
    private var completionCount = 0
    
    deinit {
        cancellAllActiveDownloads()
        Loger.success("deinit \(String(describing: self))")
    }
    
    func getDataSize(data: Data?, allowedUnits: ByteCountFormatter.Units = .useKB) -> Double? {
        guard let data = data else { return nil }
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = allowedUnits
        bcf.countStyle = .file
        let string = bcf.string(for: Int64(data.count))
        guard let num = string?.getNumbers().first else { return nil }
        return Double(truncating: num)
    }
    
    func downloadImages(urls: [String], keys: [T], completion: @escaping (T, Double?) -> (), allImagesDownloaded: @escaping () -> ()) {
        guard urls.count == keys.count else {
            Loger.error("ImageDownloader >> Number of URLs and number of keys do not match")
            return
        }
        
        completionCount = 0
        
        for i in 0..<urls.count {
            let urlString = urls[i]
            let key = keys[i]
            
            if let url = URL(string: urlString) {
                downloadQueue.async { [weak self] in
                    self?.semaphore.wait()
                    let downloadTask = KingfisherManager.shared.retrieveImage(with: url, options: [.diskStoreWriteOptions(.noFileProtection), .cacheOriginalImage]) { results in
                        defer {
                            self?.semaphore.signal()
                        }
                        
                        switch results {
                        case .success(let value):
                            if let data = value.image.jpegData(compressionQuality: 1.0) {
                                ImageCache.default.storeToDisk(data, forKey: value.source.cacheKey, callbackQueue: .mainAsync) { _ in
                                    completion(keys[i], self?.getDataSize(data: data))
                                }
                            } else {
                                completion(keys[i], self?.getDataSize(data: value.data()))
                            }
                            
                            self?.completionCount += 1
                            if self?.completionCount == urls.count {
                                allImagesDownloaded()
                            }
                        case .failure(let kfError):
                            Loger.error("KFError: \(kfError)")
                            break
                        }
                    }
                    
                    DispatchQueue.global(qos: .utility).async {
                        self?.activeDownloads[key] = downloadTask
                    }
                }
                
            } else {
                completionCount += 1
                if completionCount == urls.count {
                    allImagesDownloaded()
                }
            }
        }
    }
    
    func cancelDownload(key: T) {
        let task = activeDownloads[key]
        task??.cancel()
        activeDownloads[key] = nil
    }
    
    func cancellAllActiveDownloads() {
        for item in activeDownloads {
            cancelDownload(key: item.key)
        }
    }
}
