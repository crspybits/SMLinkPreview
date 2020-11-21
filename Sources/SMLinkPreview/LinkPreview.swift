//
//  LinkPreview.swift
//  SMLinkPreview
//
//  Created by Christopher G Prince on 4/22/19.
//

import UIKit

public class LinkPreview: UIView {
    @IBOutlet weak var topLevelView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet public weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var textAndIconContainer: UIView!
    public var textAndIconAction:(()->())?
    private var haveImage: Bool = false
    private var doneSetup = false
    
    public enum LoadedImage {
        case large(UIImage)
        case icon(UIImage)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        initSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    // Adapted from https://medium.com/@chris.mash/loading-nibs-in-ios-9a9c4b05985f
    private func initSubviews() {
        let nibName = String(describing: type(of: self))
        let bundle: Bundle
        
        // Bundle.module is available when we're using SPM. https://useyourloaf.com/blog/add-resources-to-swift-packages/
        // https://darjeelingsteve.com/articles/How-to-Use-Module-Resources-in-Objective-C-SPM-Packages.html
        #if SWIFT_PACKAGE
            bundle = Bundle.module
        #else
            bundle = Bundle(for: Self.self)
        #endif
        
        if let nib = bundle.loadNibNamed(nibName, owner: self),
            let nibView = nib.first as? UIView {
            frame = nibView.bounds
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(nibView)
        }
    }
    
    public static func create(with linkData: LinkData, callback:((_ image: LoadedImage?)->())? = nil) -> LinkPreview {
        let preview = LinkPreview()
        preview.setup(with: linkData, callback: callback)
        return preview
    }

    /// Call setup after calling this.
    public static func create() -> LinkPreview {
        return LinkPreview()
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
            haveImage = true
            image.image = UIImage(data: data)
            if let image = image.image {
                result = .large(image)
            }
            applyCornerRounding(view: contentView)
            iconContainerWidth.constant = 0
            layoutIfNeeded()
            frame.size.height = textAndIconContainer.frame.height + image.frame.height
        }
        else {
            haveImage = false

            // No image; just have text area (title, URL) below.
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
            frame.size.height = textAndIconContainer.frame.height
        }
        
        callback?(result)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if haveImage {
            imageHeight.constant =
                max(frame.size.height - textAndIconContainer.frame.height, 0)
        }
    }
    
    func applyCornerRounding(view: UIView) {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
    }
    
    @IBAction func textAndIconAction(_ sender: Any) {
        textAndIconAction?()
    }
}
