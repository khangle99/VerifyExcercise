import Foundation
import UIKit

extension UIImageView {
    
    func loadFromUrl(urlString: String, cache: NSCache<NSString, NSData>) {
        if let dataCached = cache.object(forKey: urlString as NSString) {
            self.image = UIImage.init(data: Data(referencing: dataCached))
        } else {
            downloaded(from: urlString, cache: cache)
        }
    }
    
    private func downloaded(from urlString: String, cache: NSCache<NSString, NSData>) {
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            cache.setObject(NSData(data: data), forKey: urlString as NSString)
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
}
