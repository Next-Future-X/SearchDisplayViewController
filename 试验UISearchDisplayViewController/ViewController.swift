//
//  ViewController.swift
//  试验UISearchDisplayViewController
//
//  Created by 袁向阳 on 17/4/18.
//  Copyright © 2017年 YXY.cn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var searchBar : UISearchBar!
    private var tableView : UITableView!
    private var dataArray = [Model]()
    private var searchResultArray = [Model]()
    private var searchVC : UISearchDisplayController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        /// 去掉视图延伸效果 (但导航栏会变成灰色, 需要去掉半透明效果)
        edgesForExtendedLayout = UIRectEdge.None
        navigationController?.navigationBar.translucent = false
        
        if let name : String = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String ?? "" {
            title = name
        }
        addRightSearchItem()
        setUpSearchBar()
        setUpTableView()
        setUpSearchDisplayVC()
        
        for i in 0..<15 {
            let model = Model()
            model.name = NSString(format: "%02d", i) as String
            if i % 2 > 0 {
                model.subName = NSString(format: "第%02d个", i + 1) as String
            } else {
                model.subName = NSString(format: "当前是第%02d个", i + 1) as String
            }
            dataArray.append(model)
        }
        searchResultArray = dataArray
        tableView.reloadData()
    }
    
    private func addRightSearchItem() {
        let button = UIButton(type: UIButtonType.System)
        let image = UIImage(named: "sousuo_nav_gray_40x40")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        button.setImage(image, forState: UIControlState.Normal)
        button.setImage(image, forState: UIControlState.Highlighted)
        button.frame = CGRectMake(0, 0, image?.size.width ?? 25, image?.size.height ?? 25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(ViewController.searchButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @objc private func searchButtonAction() {
        searchVC.setActive(true, animated: true)
    }
    
    private func setUpTableView() {
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.showsVerticalScrollIndicator = false
        tableView.frame = CGRectMake(0, searchBar.frame.maxY, view.bounds.size.width, view.bounds.size.height - searchBar.frame.maxY - 64)
        view.addSubview(tableView)
        tableView.keyboardDismissMode = .OnDrag
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpSearchBar() {
        searchBar = UISearchBar(frame: CGRectMake(0, 0, view.bounds.size.width, 44))
        searchBar.placeholder = "请输入搜索内容"
        searchBar.searchBarStyle = .Prominent
        searchBar.returnKeyType = .Search
        searchBar.enablesReturnKeyAutomatically = true
        view.addSubview(searchBar)
        searchBar.delegate = self
    }
    
    private func setUpSearchDisplayVC() {
        if searchVC == nil {
            searchVC = UISearchDisplayController(searchBar: self.searchBar, contentsController: self)
            //searchVC.displaysSearchBarInNavigationBar = true
            searchVC.delegate = self
            searchVC.searchResultsDelegate = self
            searchVC.searchResultsDataSource = self
            searchVC.searchResultsTitle = "搜索结果"
        }
    }
    
}

//MARK: UITableViewDelegate / UITableViewDataSource
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("dd")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "dd")
        }
        if indexPath.row < searchResultArray.count {
            cell?.textLabel?.text = searchResultArray[indexPath.row].name
            cell?.detailTextLabel?.text = searchResultArray[indexPath.row].subName
            cell?.detailTextLabel?.textColor = UIColor.darkGrayColor()
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ViewController : UISearchDisplayDelegate {
    
    /// 在这里调整取消按钮的样式
    func searchDisplayControllerDidBeginSearch(controller: UISearchDisplayController) {
        for subview in searchVC.searchBar.subviews[0].subviews {
            //print(subview)
            if subview is UIButton {
                let button = subview as! UIButton
                //button.setTitle("取消", forState: UIControlState.Normal)
                button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            }
        }
    }
    /// 重置数据
    func searchDisplayController(controller: UISearchDisplayController, didHideSearchResultsTableView tableView: UITableView) {
        self.searchResultArray = self.dataArray
    }
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        return true
    }
}

//MARK: UISearchBarDelegate
extension ViewController : UISearchBarDelegate {
    /// 利用谓词匹配检索数据
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "SELF.name contains[c] %@ or SELF.subName contains[c] %@ or SELF.pinYin contains[c] %@", searchText, searchText, searchText)
        let array = NSArray(array: dataArray).filteredArrayUsingPredicate(predicate)
        if let tmpArray = array as? [Model] {
            searchResultArray = tmpArray
            searchVC.searchResultsTableView.reloadData()
        }
    }
}
