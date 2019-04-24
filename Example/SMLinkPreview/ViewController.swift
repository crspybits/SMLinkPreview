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
    var rowData = [LinkPreview]()
    let reuseId = "ReuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.allowsSelection = false
        
        let data1 = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Home sweet home", description: "Welcome to my web page. Web pages are funny (they make me laugh). A store front for a person. An Internet presence. Information about yourself that every-internet-navigating person on the planet above age two can access. Is it the truth? Perhaps it’s Google-true?", image: URL(string: "http://cprince.com/WordPress/wp-content/uploads/2013/10/tree-225x300.jpg"), icon: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/11/IMG_09254.jpg"))
        let preview1 = LinkPreview.create(with: data1)        
        rowData += [preview1]
        
        let data1b = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Home sweet home and more text for the title", description: "Welcome to my web page. Web pages are funny (they make me laugh). A store front for a person. An Internet presence. Information about yourself that every-internet-navigating person on the planet above age two can access. Is it the truth? Perhaps it’s Google-true?", image: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/10/tree-225x300.jpg"), icon: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/11/IMG_09254.jpg"))
        let preview1b = LinkPreview.create(with: data1b)
        rowData += [preview1b]
 
         let data2 = LinkData(url: URL(string: "http://www.cprince.com")!, title: nil, description: nil, image: nil, icon: nil)
        let preview2 = LinkPreview.create(with: data2)
        rowData += [preview2]
        
        let data3 = LinkData(url: URL(string: "http://www.cprince.com")!, title: nil, description: nil, image: nil, icon: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/11/IMG_09254.jpg"))
        let preview3 = LinkPreview.create(with: data3)
        rowData += [preview3]
        
        let data4 = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Home sweet home and more text for the title", description: nil, image: nil, icon: URL(string: "https://cprince.com/WordPress/wp-content/uploads/2013/11/IMG_09254.jpg"))
        let preview4 = LinkPreview.create(with: data4)
        rowData += [preview4]
        
        let data5 = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Home sweet home and more text for the title", description: nil, image: nil, icon: nil)
        let preview5 = LinkPreview.create(with: data5)
        rowData += [preview5]
        
        PreviewManager.session.config = PreviewConfiguration(maxNumberTitleLines: 1)
        let data6 = LinkData(url: URL(string: "http://www.cprince.com")!, title: "Only a single line despite how much text I type because I forced it to be so.", description: nil, image: nil, icon: nil)
        let preview6 = LinkPreview.create(with: data6)
        rowData += [preview6]
        PreviewManager.session.config = PreviewConfiguration()

        rowData.forEach({
            print("View height: \($0.frame.height)")
        })
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.contentView.subviews.forEach({$0.removeFromSuperview()})
        let row = rowData[indexPath.row]
        row.frame.origin.x = 10
        cell.contentView.addSubview(row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = rowData[indexPath.row]
        return row.frame.height + 5
    }
}
