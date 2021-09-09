import UIKit

class MovieListVC: UIViewController {
    
    let dbManager: DBManager
    var movieList = [Movie]()
    let imageCache = NSCache<NSString, NSData>()
    let networkReach = NetworkReach()
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    init(nibName: String, bundle: Bundle, dbManager: DBManager) {
        self.dbManager = dbManager
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        networkReach.observeReachability { (isConnected) in
            if (isConnected) {
                TheMovieDBApi().fetchDiscovery { [self] (movies) -> Void in
                    if let movies = movies {
                        dbManager.invalidateMovies(movies: movies)
                    } else {
                        self.showToast(controller: self, message: "Empty list", seconds: 2)
                    }
                }
            } else {
                self.showToast(controller: self, message: "No Connection", seconds: 2)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dbManager.observeMovies { (movies) in
            self.movieList = movies
            self.movieCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dbManager.releaseMoviesObserve()
        networkReach.removeObserve()
    }
    
    private func setupCollectionView() {
        movieCollectionView.register(MovieCell.nib(), forCellWithReuseIdentifier: MovieCell.cellId)
        
        let layout = UICollectionViewFlowLayout()
        let itemWidth = view.frame.width/2 - 20
        let itemHeight = 200
        layout.itemSize = CGSize(width: itemWidth, height: CGFloat(itemHeight))
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        movieCollectionView.collectionViewLayout = layout
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
    }
}

extension MovieListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.cellId, for: indexPath) as! MovieCell
        cell.configure(movieList[indexPath.row],cache: imageCache)
        cell.delegate = self
        return cell
    }
}

extension MovieListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movieList[indexPath.row]
        let detailVC = MovieDetailVC.fromNib()
        detailVC.movie = selectedMovie
        presentFullScreen(detailVC, animated: true)
    }
}

extension MovieListVC: MovieCellDelegate {
    func favouriteToggle(movie: Movie) {
        dbManager.toggleFavourite(movie: movie)
    }
    
    func watchListToggle(movie: Movie) {
        dbManager.toggleWatchlist(movie: movie)
    }
}
