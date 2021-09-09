import UIKit

class FavouriteMovieVC: UIViewController {
    
    let dbManager: DBManager
    @IBOutlet weak var favouriteTableView: UITableView!
    private var favouriteMovies = [Movie]()
    private let cache = NSCache<NSString, NSData>()
    
    init(nibName : String, bundle: Bundle, dbManager: DBManager) {
        self.dbManager = dbManager
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavouriteTableView()
    }
    
    func setupFavouriteTableView() {
        favouriteTableView.register(FavouriteMovieCell.nib(), forCellReuseIdentifier: FavouriteMovieCell.cellId)
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dbManager.observeFavourite { (movies) in
            self.favouriteMovies = movies
            self.favouriteTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dbManager.releaseFavouriteObserve()
    }
}

extension FavouriteMovieVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteMovieCell.cellId, for: indexPath) as! FavouriteMovieCell
        cell.configure(movie: favouriteMovies[indexPath.row], cache: cache)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            dbManager.toggleFavourite(movie: favouriteMovies[indexPath.row])
        }
    }
}

extension FavouriteMovieVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = favouriteMovies[indexPath.row]
        let detailVC = MovieDetailVC.fromNib()
        detailVC.movie = selectedMovie
        presentFullScreen(detailVC, animated: true)
    }
}
