import Foundation

protocol TheMovieDBApiProtocol {
    func fetchDiscovery(completion: @escaping ([Movie]?) -> Void)
}

class TheMovieDBApi: TheMovieDBApiProtocol {
    
    var baseUrl = URL(string: "https://api.themoviedb.org/3/discover")!
    var imageBaseUrlString = "https://image.tmdb.org/t/p/w500"
    let apiKey = "841dc181068eabb19b0fe6b4d6318aa2"
    
    func fetchDiscovery(completion: @escaping ([Movie]?) -> Void) {
        var urlComponent = URLComponents.init(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponent.path = Endpoints.movie.rawValue
        urlComponent.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                                   URLQueryItem(name: "page", value: String(1))]
        
        URLSession.shared.dataTask(with: urlComponent.url!) { (data, response, error)  in
            if let error = error {
                print(error)
                return
            }
            
            guard let res = response as? HTTPURLResponse,(200..<300).contains(res.statusCode) else { return }
            
            if let resData = data {
                let fetchResult = try? JSONDecoder().decode(FetchResult<Movie>.self, from: resData)
                self.prependBaseUrl(movies: fetchResult?.results)
                DispatchQueue.main.async {
                    completion(fetchResult?.results)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
               
            }
        }.resume()
    }
    
    func prependBaseUrl(movies: [Movie]?) {
        movies?.forEach { (movie) in
            movie.wallpaperPath = imageBaseUrlString + movie.wallpaperPath
        }
    }
}

