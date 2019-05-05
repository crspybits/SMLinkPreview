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
    
    public enum LoadedImage {
        case large(UIImage)
        case icon(UIImage)
    }
    
    public static func create(with linkData: LinkData, callback:((_ image: LoadedImage?)->())? = nil) -> LinkPreview {
        let preview = create()
        preview.setup(with: linkData, callback: callback)
        return preview
    }
    
    /// Call setup after calling tthis.
    public static func create() -> LinkPreview {
        let preview = Bundle(for: LinkPreview.self).loadNibNamed("LinkPreview", owner: self)![0] as! LinkPreview
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
    
    /// The image is passed back in the form of a callback to allow for asynchronous image loading if needed.
    // Image data are loaded from the linkData icon/image URL's, if non-nil. Those URL's can refer to either local or remote files.
    public func setup(with linkData: LinkData, callback:((_ image: LoadedImage?)->())? = nil) {
        title.numberOfLines = Int(PreviewManager.session.config.maxNumberTitleLines)
        title.text = linkData.title
        url.text = linkData.url.urlWithoutScheme()
        
        var forceScheme:URL.ForceScheme?
        if PreviewManager.session.config.alwaysUseHTTPS {
            forceScheme = .https
        }
        
        var result:LoadedImage?
        
        if let imageURL = linkData.image,
            let data = try? Data(contentsOf: imageURL.attemptForceScheme(forceScheme)) {
            image.image = UIImage(data: data)
            if let image = image.image {
                result = .large(image)
            }
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
                    if let icon = icon.image {
                        result = .icon(icon)
                    }
                }
            }
            else {
                iconContainerWidth.constant = 0
            }
            
            imageHeight.constant = 0
            layoutIfNeeded()
            self.frame.size.height = textAndIconContainer.frame.height
        }
        
        callback?(result)
    }
    
    func applyCornerRounding(view: UIView) {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
    }
}
