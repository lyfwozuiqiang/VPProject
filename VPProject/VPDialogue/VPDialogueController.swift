//
//  VPDialogueController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/20.
//

import UIKit

class VPDialogueController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        
        let dialogueView = VPDialogueView.init()
        dialogueView.title = "Chọn câu bạn muốn học"
        dialogueView.dialogueArray = ["Chọn câu bạn muốn học","Chọn câu bạn muốn học Chọn câu bạn muốn học","Chọn câu bạn muốn học Chọn câu bạn muốn học Chọn câu bạn muốn học","Chọn câu bạn muốn học Chọn câu bạn muốn học Chọn câu bạn muốn học Chọn câu bạn muốn học","Chọn câu bạn muốn học Chọn câu bạn muốn học Chọn câu bạn muốn học Chọn câu bạn muốn học Chọn câu bạn muốn học"]
        view.addSubview(dialogueView)
        dialogueView.translatesAutoresizingMaskIntoConstraints = false
        dialogueView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dialogueView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dialogueView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dialogueView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
