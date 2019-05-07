//
//  ViewController.swift
//  SMLinkPreview
//
//  Created by crspybits on 04/20/2019.
//  Copyright (c) 2019 crspybits. All rights reserved.
//

import UIKit
import SMLinkPreview

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var rowData = [LinkData]()
    var rowViews = [LinkPreview]()
    let reuseId = "ReuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LinkPreviewCell", bundle: nil), forCellReuseIdentifier: reuseId)
        tableView.allowsSelection = false
        
        func add(datum: LinkData, proportion: CGFloat = 1.0) {
            let preview = LinkPreview.create(with: datum)
            preview.heightAnchor.constraint(equalToConstant: preview.frame.height*proportion).isActive = true
            preview.widthAnchor.constraint(equalToConstant: preview.frame.width*proportion).isActive = true
            preview.translatesAutoresizingMaskIntoConstraints = false
            rowViews += [preview]
        }
 
        let data0 = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Home sweet home", description: "Welcome to my web page. Web pages are funny (they make me laugh). A store front for a person. An Internet presence. Information about yourself that every-internet-navigating person on the planet above age two can access. Is it the truth? Perhaps it’s Google-true?", image: URL(string: "http://cprince.com/WordPress/wp-content/uploads/2013/10/tree-225x300.jpg"), icon: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/11/IMG_09254.jpg"))
        add(datum: data0, proportion: 0.75)
        
        let data1 = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Home sweet home", description: "Welcome to my web page. Web pages are funny (they make me laugh). A store front for a person. An Internet presence. Information about yourself that every-internet-navigating person on the planet above age two can access. Is it the truth? Perhaps it’s Google-true?", image: URL(string: "http://cprince.com/WordPress/wp-content/uploads/2013/10/tree-225x300.jpg"), icon: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/11/IMG_09254.jpg"))
        rowData += [data1]
        
        let data1b = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Home sweet home and more text for the title", description: "Welcome to my web page. Web pages are funny (they make me laugh). A store front for a person. An Internet presence. Information about yourself that every-internet-navigating person on the planet above age two can access. Is it the truth? Perhaps it’s Google-true?", image: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/10/tree-225x300.jpg"), icon: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/11/IMG_09254.jpg"))
        rowData += [data1b]
 
         let data2 = LinkData(url: URL(string: "http://www.cprince.com")!, title: nil, description: nil, image: nil, icon: nil)
        rowData += [data2]
        
        let data3 = LinkData(url: URL(string: "http://www.cprince.com")!, title: nil, description: nil, image: nil, icon: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/11/IMG_09254.jpg"))
        rowData += [data3]
        
        let data4 = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Home sweet home and more text for the title", description: nil, image: nil, icon: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/11/IMG_09254.jpg"))
        rowData += [data4]
        
        let data5 = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Home sweet home and more text for the title", description: nil, image: nil, icon: nil)
        rowData += [data5]
        
        for datum in rowData {
            add(datum: datum)
        }
        
        PreviewManager.session.config = PreviewConfiguration(maxNumberTitleLines: 1)
        let data6 = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Only a single line despite how much text I type because I forced it to be so.", description: nil, image: nil, icon: nil)
        add(datum: data6)
        PreviewManager.session.config = PreviewConfiguration()
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! LinkPreviewCell
        let preview = rowViews[indexPath.row]
        cell.setup(with: preview)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let preview = rowViews[indexPath.row]
        let height = preview.frame.height + LinkPreviewCell.verticalPadding
        return height
    }
}
