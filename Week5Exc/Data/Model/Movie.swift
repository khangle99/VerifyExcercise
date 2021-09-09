import Foundation
import RealmSwift

class Movie: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title = ""
    @Persisted var wallpaperPath = ""
    @Persisted var releaseDate = ""
    @Persisted var overview = ""
    @Persisted var popularity: Float
    @Persisted var voteAverage: Float
    @Persisted var voteCount: Int
    @Persisted var isFavourite = false
    @Persisted var isWatchListAdded = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case wallpaperPath = "backdrop_path"
        case releaseDate = "release_date"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
