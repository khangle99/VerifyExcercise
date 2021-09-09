import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        let tabBarControler = UITabBarController()
        let realmManager = RealmManager()
        
        let movieListVC = MovieListVC(nibName: "MovieListVC", bundle: .main, dbManager: realmManager)
        movieListVC.tabBarItem = UITabBarItem(title: "Movie", image: UIImage(named: "ico_movie_unselected"), selectedImage: UIImage(named: "ico_movie_selected"))
        
        let watchListVC = WatchListVC(nibName: "WatchListVC", bundle: .main, dbManager: realmManager)
        watchListVC.tabBarItem = UITabBarItem(title: "Watch List", image: UIImage(named: "ico_watch_unselected"), selectedImage: UIImage(named: "ico_watch_selected"))
        
        let favMovieVC = FavouriteMovieVC(nibName: "FavouriteMovieVC", bundle: .main, dbManager: realmManager)
        favMovieVC.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(named: "ico_fav_unselected"), selectedImage: UIImage(named: "ico_fav_selected"))
        
        tabBarControler.viewControllers = [movieListVC, favMovieVC, watchListVC]
        window.rootViewController = tabBarControler
        self.window = window
        window.makeKeyAndVisible()
    }
}

