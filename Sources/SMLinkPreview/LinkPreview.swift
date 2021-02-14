//
//  LinkPreview.swift
//  SMLinkPreview
//
//  Created by Christopher G Prince on 4/22/19.
//

// By default: This resizes its height to what it needs to have to present its `LinkData`. It keeps the width you set.
// If you don't want this behavior, use the `LinkPreviewSizing` parameter below.

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
    var sizing:LinkPreviewSizing?
    
    public enum LoadedImage {
        case large(UIImage)
        case icon(UIImage)
        
        public var image: UIImage {
            switch self {
            case .large(let image):
                return image
            case .icon(let image):
                return image
            }
        }
        
        public enum ImageType: String {
            case icon
            case large
        }
        
        public var imageType: ImageType {
            switch self {
            case .large:
                return .large
            case .icon:
                return .icon
            }
        }
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
    
    public static func create(with linkData: LinkData, sizing:LinkPreviewSizing? = nil, callback:((_ image: LoadedImage?)->())? = nil) -> LinkPreview {
        let preview = LinkPreview()
        preview.setup(with: linkData, sizing: sizing, callback: callback)
        return preview
    }

    /// Call setup after calling this.
    public static func create() -> LinkPreview {
        return LinkPreview()
    }
    
    /// The image is passed back in the form of a callback to allow for asynchronous image loading if needed.
    // Image data are loaded from the linkData icon/image URL's, if non-nil. Those URL's can refer to either local or remote files.
    public func setup(with linkData: LinkData, sizing:LinkPreviewSizing? = nil, callback:((_ image: LoadedImage?)->())? = nil) {
        self.sizing = sizing
        
        title.text = linkData.title
        url.text = linkData.url.urlWithoutScheme()

        var forceScheme:URL.ForceScheme?
        if PreviewManager.session.config.alwaysUseHTTPS {
            forceScheme = .https
        }
        
        var result:LoadedImage?
        
        let heightIsResizable = sizing?.resizingAllowed ?? false

        title.numberOfLines = Int(PreviewManager.session.config.maxNumberTitleLines)

        if let sizingNumberTitleLines = sizing?.titleLabelNumberOfLines {
            title.numberOfLines = sizingNumberTitleLines
        }
        
        if let imageURL = linkData.image,
            let data = try? Data(contentsOf: imageURL.attemptForceScheme(forceScheme)) {
            haveImage = true
            image.image = UIImage(data: data)
            
            if let image = getImage(image: image.image) {
                result = .large(image)
            }
            
            applyCornerRounding(view: contentView)
            
            // Not showing the icon-- because we have the large image
            iconContainerWidth.constant = 0
            
            layoutIfNeeded()
            
            if heightIsResizable {
                frame.size.height = textAndIconContainer.frame.height + image.frame.height
            }
            else {
                // We can't change the height of the `LinkPreview`. Change the imageHeight to the most it can have.
                imageHeight.constant = max(frame.size.height - textAndIconContainer.frame.height, 0)
            }
        }
        else {
            haveImage = false

            // No image; just have text area (title, URL) below.
            applyCornerRounding(view: textAndIconContainer)
            
            if let iconURL = linkData.icon {
                if let data = try? Data(contentsOf: iconURL.attemptForceScheme(forceScheme)) {
                    icon.image = UIImage(data: data)

                    if let image = getImage(image: image.image) {
                        result = .icon(image)
                    }
                }
            }
            else {
                // No image, no icon. Hide the icon.
                iconContainerWidth.constant = 0
            }
            
            // No image.
            imageHeight.constant = 0
            
            layoutIfNeeded()
            frame.size.height = textAndIconContainer.frame.height
        }
        
        callback?(result)
    }
    
    func getImage(image: UIImage?) -> UIImage? {
        if let minAspectRatio = PreviewManager.session.config.minimumImageAspectRatio {
            if let image = image,
                image.size.aspectRatioOK(minimumAspectRatio: minAspectRatio) {
                return image
            }
            else {
                return nil
            }
        }
        return image
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

extension CGSize {
    func aspectRatioOK(minimumAspectRatio: CGFloat = 0.05) -> Bool {
        if width == 0 || height == 0 {
            return false
        }
        
        let maxDim = max(width, height)
        let minDim = min(width, height)
        return (minDim / maxDim) >= minimumAspectRatio
    }
}
