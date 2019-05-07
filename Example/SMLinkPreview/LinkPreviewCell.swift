//
//  LinkPreviewCell.swift
//  SMLinkPreview_Example
//
//  Created by Christopher G Prince on 5/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SMLinkPreview

class LinkPreviewCell: UITableViewCell {
    static let verticalPadding:CGFloat = 20
    @IBOutlet weak var previewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with linkPreview: LinkPreview) {
        previewContainer.subviews.forEach {$0.removeFromSuperview()}
        previewContainer.addSubview(linkPreview)
    }
}
