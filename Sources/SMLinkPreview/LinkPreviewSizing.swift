
import Foundation

public struct LinkPreviewSizing {
    // Can the height of the `LinkPreview` be adapted to fit the `LinkData`?
    public var resizingAllowed: Bool = true
    
    // The value for `title.numberOfLines`-- 0 means no limit. If you set `resizingAllowed` - false, it's best to set this to 1 or 2.
    // This overrides, if LinkPreviewSizing is non-nil, the `maxNumberTitleLines` value given in `PreviewConfiguration`.
    public var titleLabelNumberOfLines:Int = 0
    
    public init(resizingAllowed: Bool = true, titleLabelNumberOfLines:Int = 0) {
        self.resizingAllowed = resizingAllowed
        self.titleLabelNumberOfLines = titleLabelNumberOfLines
    }
}
