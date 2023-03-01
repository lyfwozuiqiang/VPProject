//
//  ViewController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/16.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet private weak var listTableView: UITableView!
    
    private let listArray:Array = [
        ["title":"词卡错误划线","class":"VPBorderLabelController"],
        ["title":"倍速+字幕UI（背景模糊）","class":"VPItemsSelectController"],
        ["title":"选择对白","class":"VPDialogueController"],
        ["title":"声波动画","class":"VPLineWaveController"],["title":"结束页面","class":"VPFinishedController"],
        ["title":"多边形Border","class":"VPPolygonBorderController"],
        ["title":"读音气泡","class":"VPPronounceController"],
        ["title":"学习报告","class":"VPLearningReportController"],
        ["title":"跟读结果动画","class":"VPFollowReadingController"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
    }
    
    //MARK: —— UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as! ListTableViewCell
        listCell.titleString = listArray[indexPath.row]["title"]
        return listCell
    }
    
    //MARK: —— UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let classString = listArray[indexPath.row]["class"]!
        let vcClass = NSClassFromString("VPProject.\(classString)") as! UIViewController.Type
        let viewController = vcClass.init()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

