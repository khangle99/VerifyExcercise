import UIKit

protocol MovieCellDelegate: class {
    func favouriteToggle(movie: Movie)
    func watchListToggle(movie: Movie)
}


class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var addWatchListButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    
    weak var delegate: MovieCellDelegate?
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCard()
        setupButtons()
    }
    
    private func setupButtons() {
        favouriteButton.layer.cornerRadius = 10
    }
    
    private func setupCard() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        // border
        contentView.layer.borderWidth = 0.1
        contentView.layer.borderColor = UIColor.black.cgColor
        // shadow
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 4.0
        // optimize performance
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func configure(_ movie: Movie, cache: NSCache<NSString, NSData>) {
        self.movie = movie
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        popularityLabel.text = "\(Int(movie.popularity)) pts"
        backdropImageView.loadFromUrl(urlString: movie.wallpaperPath, cache: cache)
        setButtonState(isFavourite: movie.isFavourite, isWatchListAdd: movie.isWatchListAdded)
    }
    
    private func setButtonState(isFavourite: Bool, isWatchListAdd: Bool) {
        if (isFavourite) {
            favouriteButton.setImage(UIImage(named: "ico_fav_selected"), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(named:"ico_fav_unselected"), for: .normal)
        }
        
        if (isWatchListAdd) {
            addWatchListButton.setImage(UIImage(named: "ico_watch_selected"), for: .normal)
        } else {
            addWatchListButton.setImage(UIImage(named: "ico_watch_unselected"), for: .normal)
        }
    }

    @IBAction func toggleFavourite(_ sender: Any) {
        delegate?.favouriteToggle(movie: movie!)
    }
    
    @IBAction func toggleWatchList(_ sender: Any) {
        delegate?.watchListToggle(movie: movie!)
    }
    
    static let cellId = "MovieCell"
    static func nib() -> UINib {
        return UINib(nibName: "MovieCell", bundle: .main)
    }
}
