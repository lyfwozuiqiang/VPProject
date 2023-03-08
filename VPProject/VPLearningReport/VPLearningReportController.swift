//
//  VPLearningReportController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/25.
//

import UIKit

class VPLearningReportController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let greatSen = [SceneCourseSentence.init(sentenceID: nil, content: "It’s not very spacious.It’s not very spacious 111 1111 1111. It’s not very spacious.It’s not very spacious 111 1111 1111."),SceneCourseSentence.init(sentenceID: nil, content: "It’s not very spacious.It’s not very spacious. 1111 ")]
        let improveSec = [SceneCourseSentence.init(sentenceID: nil, content: "It’s not very spacious.It’s not very spacious."),SceneCourseSentence.init(sentenceID: nil, content: "It’s not very spacious.It’s not very spacious.")]
        let summary = SceneCourseStudySummary(partId: 10, partName: nil, learningDays: nil, accuracy: nil, fluency: nil, learningDuration: nil, coinNum: nil, greatSentence: nil, needImprovedSentence: nil)
        let reportView = VPLearningReportView.init(with: summary)
        reportView.quitHandler = {
            print("quitHandler")
        }
        reportView.shareHandler = {
            print("shareHandler")
        }
        view.addSubview(reportView)
        reportView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let summary = SceneCourseStudySummary(partId: 10, partName: nil, learningDays: 22, accuracy: "200%", fluency: "20%", learningDuration: 500, coinNum: 33, greatSentence: greatSen, needImprovedSentence: improveSec)
            reportView.dataModel = summary
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let data = SceneCourseStudySummary(partId: 10, partName: nil, learningDays: nil, accuracy: nil, fluency: nil, learningDuration: nil, coinNum: nil, greatSentence: nil, needImprovedSentence: nil)
                reportView.dataModel = data
            })
        })
    }
}
