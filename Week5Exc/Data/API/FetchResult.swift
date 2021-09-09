import Foundation

struct FetchResult<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
}
