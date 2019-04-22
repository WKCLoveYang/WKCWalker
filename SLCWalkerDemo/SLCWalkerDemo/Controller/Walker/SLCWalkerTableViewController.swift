//
//  SLCWalkerTableViewController.swift
//  SLCWalkerDemo
//
//  Created by WeiKunChao on 2019/4/12.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

import UIKit
import SLCWalker

class SLCWalkerTableViewController: UIViewController
{

    private lazy var tableView: UITableView = {
        let table: UITableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.backgroundView = nil
        table.backgroundColor = nil
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 150
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.t_makeScale(0.01).t_itemDuration(0.7).t_itemDelay(0.1).t_spring.reloadDataWithWalker()
    }
   

}

extension SLCWalkerTableViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}
