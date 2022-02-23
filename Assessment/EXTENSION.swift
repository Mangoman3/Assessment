//
//  EXT + UIVIEW.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/23/22.
//

import UIKit


extension String {
    
    var url: URL? {
        return URL(string: self)
    }
}


extension UIView {
    func presentActivity(_ style: UIActivityIndicatorView.Style = .large,
                         withTintColor tintColor: UIColor? = .black,
                         blockSuperView isBlockView: Bool = true) {
        if let activityIndicator = findActivity() {
            activityIndicator.startAnimating()
        } else {
            let activityIndicator = UIActivityIndicatorView(style: style)
            if let tintColor = tintColor {
                activityIndicator.assignColor(tintColor)
            }
    
            activityIndicator.startAnimating()
            self.addSubview(activityIndicator)

            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 11.0, *) {
                NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
                    ])
                activityIndicator.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor).isActive = isBlockView
                activityIndicator.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor).isActive = isBlockView
            } else {
                NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                    ])
                activityIndicator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = isBlockView
                activityIndicator.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = isBlockView
            }
        }
    }

    func dismissActivity() {
        findActivity()?.stopAnimating()
    }

    func findActivity() -> UIActivityIndicatorView? {
        return self.subviews.lazy.compactMap { $0 as? UIActivityIndicatorView }.first
    }
}

extension UIActivityIndicatorView {
    func assignColor(_ color: UIColor) {
        self.color = color
    }
}
