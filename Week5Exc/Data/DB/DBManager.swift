import Foundation
import RealmSwift

protocol DBManager {
    
    func invalidateMovies(movies: [Movie])
    func observeFavourite(handle: @escaping ([Movie]) -> Void)
    func releaseFavouriteObserve()
    func observeWatchlist(handle: @escaping ([Movie]) -> Void)
    func releaseWatchObserve()
    func observeMovies(handle: @escaping ([Movie]) -> Void)
    func releaseMoviesObserve()
    func toggleFavourite(movie: Movie)
    func toggleWatchlist(movie: Movie)
}

class RealmManager: DBManager {
    
    let realm: Realm
    var moviesToken: NotificationToken?
    var favMoviesToken: NotificationToken?
    var watchMoviesToken: NotificationToken?
    init() {
        realm = try! Realm()
    }
    
    func observeMovies(handle: @escaping ([Movie]) -> Void) {
        
        moviesToken = realm.objects(Movie.self).observe { (resultChange) in
            switch resultChange {
            case .initial(let result):
                handle(Array(result))
            case .update(let result, _,  _,  _):
                handle(Array(result))
            default:
                break
                
            }
        }
    }
    
    func releaseMoviesObserve() {
        moviesToken?.invalidate()
    }
    
    func invalidateMovies(movies: [Movie]) {
        try! realm.write {
            movies.forEach { (movie) in
                realm.create(Movie.self,
                             value: ["id": movie.id,
                                     "title": movie.title,
                                     "wallpaperPath": movie.wallpaperPath,
                                     "releaseDate": movie.releaseDate,
                                     "overview": movie.overview,
                                     "popularity": movie.popularity,
                                     "voteAverage": movie.voteAverage,
                                     "voteCount": movie.voteCount
                             ],
                             update: .modified)
            }
        }
    }
    
    func toggleFavourite(movie: Movie) {
        try! realm.write {
            movie.isFavourite.toggle()
        }
    }
    
    func toggleWatchlist(movie: Movie) {
        try! realm.write {
            movie.isWatchListAdded.toggle()
        }
    }
    
    func observeWatchlist(handle: @escaping ([Movie]) -> Void) {
        watchMoviesToken = realm.objects(Movie.self).filter("isWatchListAdded == true").observe { (resultChange) in
            switch resultChange {
            case .initial(let result):
                handle(Array(result))
            case .update(let result, _,  _,  _):
                handle(Array(result))
            default:
                break
            }
        }
    }
    
    func releaseWatchObserve() {
        watchMoviesToken?.invalidate()
    }
    
    func observeFavourite(handle: @escaping ([Movie]) -> Void) {
        favMoviesToken = realm.objects(Movie.self).filter("isFavourite == true").observe { (resultChange) in
            switch resultChange {
            case .initial(let result):
                handle(Array(result))
            case .update(let result, _,  _,  _):
                handle(Array(result))
            default:
                break
                
            }
        }
    }
    func releaseFavouriteObserve() {
        favMoviesToken?.invalidate()
    }
}
