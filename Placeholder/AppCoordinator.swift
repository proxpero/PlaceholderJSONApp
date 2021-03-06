
import UIKit

/// A class to encapsulate the logic involved in presenting view controllers
/// and wiring view models to views. This is nice because it keeps the view
/// controllers isolated and dumb.
final class AppCoordinator {

    // Keep a reference to the window's navigation controller.
    var navigationController: UINavigationController!

    // The webservice will automatically cache responses it makes on the network.
    private let webservice = CachedWebservice.shared

    // The URL host of the service.
    private let urlProvider = URLProvider(host: "jsonplaceholder.typicode.com")

    init(window: UIWindow) {

        // Set the url info on the `Route`.
        Route.urlProvider = urlProvider

        // Create an ItemsViewController for users.
        let usersViewController = ItemsViewController() { (user: User) in
            return CellDescriptor(
                reuseIdentifier: "UserCell",
                configure: user.configureCell
            )
        }

        // The first screen displays all the users.
        usersViewController.title = "Users"

        // Set a callback to display a selected album.
        usersViewController.didSelect = showAlbums

        // Grab the users asynchronously from the network.
        webservice.load(User.all).onResult { result in
            if case .success(let users) = result {
                // If the users are there, populate the `items` property
                // of the generic view controller, which will reload the 
                // table view.
                usersViewController.items = users
            }
        }

        // Initialize a navigation controller with the view controller.
        navigationController = UINavigationController(rootViewController: usersViewController)

        // Set the nav controller as the window's rootVC
        window.rootViewController = navigationController
    }

    /// Push the albums view controlller populated with albums for the selected user.
    func showAlbums(for user: User) {

        // Initialize the view controller with 0 albums, a 'profile' navigation item,
        // and a function to configure the album cells with an album.
        let albumsViewController = ItemsViewController(navigationItemTitle: "Profile") { (album: Album) in
            return CellDescriptor(
                reuseIdentifier: "AlbumCell",
                configure: album.configureCell
            )
        }

        // Set the title.
        albumsViewController.title = user.name

        // Set the callback for showing the thumbnails view controller
        // when an album row is tapped.
        albumsViewController.didSelect = showThumbnails

        // Set the callback for showing the user's profile.
        albumsViewController.didTapButton = { self.showProfile(for: user) }

        // Grab the albums for the user asynchronously from the network using ReactiveJSON.
        webservice.load(user.albums).onResult { result in
            if case .success(let albums) = result {
                albumsViewController.items = albums
            }
        }

        // Push the view controller.
        navigationController.pushViewController(albumsViewController, animated: true)
    }

    /// Show the selected user's profile view controller, modally.
    func showProfile(for user: User) {

        // Instantiate the view controller from the "Main" storyboard.
        let userProfileViewController = UIStoryboard.main.instantiate(UserProfileViewController.self)

        // Set the user.
        userProfileViewController.user = user

        // Set the callback to handle dismissing the view controller.
        userProfileViewController.dismiss = {
            self.navigationController.dismiss(animated: true, completion: nil)
        }

        // Create a new navigation controller
        let nav = UINavigationController(rootViewController: userProfileViewController)

        // Have the main navigation controller present the profile nav controller.
        navigationController.present(nav, animated: true, completion: nil)
    }

    /// Show the thumbnails of the selected album in a table view
    func showThumbnails(for album: Album) {

        // Initialize a table view controller with a cell configuration function.
        let thumbnailsViewController = ItemsViewController() { (photo: Photo) in
            return CellDescriptor(
                reuseIdentifier: "PhotoCell",
                configure: photo.configureCell
            )
        }

        // Set the title.
        thumbnailsViewController.title = album.title

        // Set a callback to display the selected photo when the user selects a row.
        thumbnailsViewController.didSelect = showPhoto

        // Grab the photos in the album asynchronously from the network.
        webservice.load(album.photos).onResult { result in
            if case .success(let photos) = result {
                thumbnailsViewController.items = photos
            }
        }

        // Push the view controller.
        navigationController.pushViewController(thumbnailsViewController, animated: true)
    }

    /// Display the selected photo.
    func showPhoto(_ photo: Photo) {

        // Instantiate the photo view controller from the "Main" storyboard.
        let photoViewController = UIStoryboard.main.instantiate(PhotoViewController.self)

        // Set the `phototitle` property (not the vc title)
        photoViewController.photoTitle = photo.title

        // Set the photoImage property to a placeholder while
        // the real image loads.
        photoViewController.photoImage = UIImage.placeholder(with: .lightGray, size: photoViewController.view.bounds.maximumSquare)

        // Asyncronously load the (possibly cached) image. Update on the
        // main queue.
        webservice.load(photo.imageResource).onResult { result in
            if case .success(let image) = result {
                DispatchQueue.main.async {
                    photoViewController.photoImage = image
                }
            }
        }

        // Push the view controller.
        navigationController.pushViewController(photoViewController, animated: true)
    }
    
}

