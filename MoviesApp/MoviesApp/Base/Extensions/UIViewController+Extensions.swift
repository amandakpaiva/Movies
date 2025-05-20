import UIKit

extension UIViewController {
    func createBackButton(title: String) -> UIBarButtonItem {
        let button = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        return button
    }
    
    func createHeartButton(title: String, target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: target,
            action: action
        )
        button.tintColor = .systemRed
        return button
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func hideLoading() {
        view.subviews.forEach { view in
            if let activityIndicator = view as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
} 