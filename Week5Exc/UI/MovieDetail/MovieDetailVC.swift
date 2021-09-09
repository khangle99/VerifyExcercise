import UIKit

class MovieDetailVC: UIViewController {
    
    var movie: Movie?
    let categories = ["Basic", "Premium", "Vip"]
    var selectedCategory = 0
    let cache = NSCache<NSString, NSData>()
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            loadData(movie: movie)
        }
        
        loadBackground()
        loadCategory()
    }
    
    private func loadCategory() {
        categoryCollectionView.register(CategoryTableViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        categoryCollectionView.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: categoryCollectionView.frame.width/3, height: categoryCollectionView.frame.height - 10)
        categoryCollectionView.collectionViewLayout = layout
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
    private func loadBackground() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor(red:158.0/255.0, green:203.0/255.0, blue:244.0/255.0, alpha:1.0).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func loadData(movie: Movie) {
        overviewLabel.text = movie.overview
        titleLabel.text = movie.title
        composeRatingString(rate: movie.voteAverage, rateCount: movie.voteCount)
        backdropImageView.loadFromUrl(urlString: movie.wallpaperPath, cache: cache)
    }
    
    private func composeRatingString(rate: Float, rateCount: Int) {
        
        let rateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        let ratingAttributeString = NSAttributedString(string: "\(rate) ⭐️", attributes: rateAttributes)
        
        let countAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        let rateCountAttributeString = NSAttributedString(string: " (\(rateCount))", attributes: countAttributes)
        let attributedText = NSMutableAttributedString()
        
        attributedText.append(ratingAttributeString)
        attributedText.append(rateCountAttributeString)
        rateLabel.attributedText = attributedText
    }
    
    @IBAction func dimissDetail(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    static func fromNib() -> MovieDetailVC {
        return MovieDetailVC.init(nibName: "MovieDetailVC", bundle: .main)
    }
}

extension MovieDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        cell.configureWith(categories[indexPath.row], isSelected: selectedCategory == indexPath.row)
        return cell
    }
}

extension MovieDetailVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = indexPath.row
        categoryCollectionView.reloadData()
    }
}
