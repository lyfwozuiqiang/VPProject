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
        
        let greatSen = [SceneCourseSentence.init(sentenceID: nil, content: "It’s not very spacious.It’s not very spacious 111 1111 1111. It’s not very spacious.It’s not very spacious 111 1111 1111."),SceneCourseSentence.init(sentenceID: nil, content: "It’s not very spacious.It’s not very spacious.")]
        let improveSec = [SceneCourseSentence.init(sentenceID: nil, content: "It’s not very spacious.It’s not very spacious."),SceneCourseSentence.init(sentenceID: nil, content: "It’s not very spacious.It’s not very spacious.")]
        let summary = SceneCourseStudySummary(partId: 10, partName: nil, learningDays: 1, accuracy: "40%", fluency: "60%", learningDuration: 200, coinNum: 100, greatSentence: greatSen, needImprovedSentence: improveSec)
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
    }
}
