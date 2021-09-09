import UIKit

class FavouriteMovieCell: UITableViewCell {

    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        backdropImageView.layer.cornerRadius = 10
    }
    
    func configure(movie: Movie, cache: NSCache<NSString, NSData>) {
        popularityLabel.text = "\(Int(movie.popularity)) pts"
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        backdropImageView.loadFromUrl(urlString: movie.wallpaperPath, cache: cache)
    }
    
    static func nib() -> UINib {
        return UINib.init(nibName: "FavouriteMovieCell", bundle: .main)
    }
    static let cellId = "FavMovieCell"
}
