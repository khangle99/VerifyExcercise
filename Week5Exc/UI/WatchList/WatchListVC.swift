import UIKit

class WatchListVC: UIViewController {
    
    @IBOutlet weak var watchListTableView: UITableView!
    let dbManager: DBManager
    private var watchList = [Movie]()
    private let cache = NSCache<NSString, NSData>()
    
    init(nibName: String, bundle: Bundle, dbManager: DBManager) {
        self.dbManager = dbManager
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWatchTableView()
    }
    
    func setupWatchTableView() {
        watchListTableView.register(FavouriteMovieCell.nib(), forCellReuseIdentifier: FavouriteMovieCell.cellId)
        watchListTableView.delegate = self
        watchListTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dbManager.observeWatchlist { [weak self] (movie) in
            self?.watchList = movie
            self?.watchListTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dbManager.releaseWatchObserve()
    }
}

extension WatchListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = watchList[indexPath.row]
        let detailVC = MovieDetailVC.fromNib()
        detailVC.movie = selectedMovie
        presentFullScreen(detailVC, animated: true)
    }
}

extension WatchListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteMovieCell.cellId, for: indexPath) as! FavouriteMovieCell
        cell.configure(movie: watchList[indexPath.row], cache: cache)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            dbManager.toggleWatchlist(movie: watchList[indexPath.row])
        }
    }
}
