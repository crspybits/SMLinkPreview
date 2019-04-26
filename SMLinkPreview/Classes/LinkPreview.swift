//
//  LinkPreview.swift
//  SMLinkPreview
//
//  Created by Christopher G Prince on 4/22/19.
//

import UIKit

public class LinkPreview: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var textAndIconContainer: UIView!
    
    public static func create(with linkData: LinkData) -> LinkPreview {
        let preview = Bundle(for: LinkPreview.self).loadNibNamed("LinkPreview", owner: self)![0] as! LinkPreview
        preview.setup(with: linkData)
        return preview
    }
    
    // To resize this view, set this:
    public var size: CGSize {
        set {
            if imageHeight.constant > 0 {
                // Going to keep the textAndIconContainer height constant when there is an image.
                imageHeight.constant = newValue.height - textAndIconContainer.frame.height
            }
            
            frame.size = newValue
        }
        get {
            return frame.size
        }
    }
    
    func setup(with linkData: LinkData) {
        title.numberOfLines = Int(PreviewManager.session.config.maxNumberTitleLines)
        title.text = linkData.title
        url.text = linkData.url.urlWithoutScheme()
        
        var forceScheme:URL.ForceScheme?
        if PreviewManager.session.config.alwaysUseHTTPS {
            forceScheme = .https
        }
        
        if let imageURL = linkData.image,
            let data = try? Data(contentsOf: imageURL.attemptForceScheme(forceScheme)) {
            image.image = UIImage(data: data)
            applyCornerRounding(view: contentView)
            iconContainerWidth.constant = 0
            layoutIfNeeded()
            self.frame.size.height = textAndIconContainer.frame.height + image.frame.height
        }
        else {
            applyCornerRounding(view: textAndIconContainer)
            
            if let iconURL = linkData.icon {
                if let data = try? Data(contentsOf: iconURL.attemptForceScheme(forceScheme)) {
                    icon.image = UIImage(data: data)
                }
            }
            else {
                iconContainerWidth.constant = 0
            }
            
            imageHeight.constant = 0
            layoutIfNeeded()
            self.frame.size.height = textAndIconContainer.frame.height
        }        
    }
    
    func applyCornerRounding(view: UIView) {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
    }
}
