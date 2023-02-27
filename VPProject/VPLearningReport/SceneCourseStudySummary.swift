//
//  SceneCourseStudySummary.swift
//  SWBaseModels
//
//  Created by Zacharyah on 2023/1/13.
//

import Foundation

// 完成页 model

public struct SceneCourseSentence: Decodable {
  
  public let sentenceID: Int?
  public let content: String?
  
  enum CodingKeys: String, CodingKey {
    case sentenceID = "id"
    case content
  }
  
}

public struct SceneCourseStudySummary: Decodable {
    
    public let partId: Int?     // 课程 id
    public let partName: String? // 课程名称
    public let learningDays: Int? // 当前课程已学天数
    public let accuracy: String?
    public let fluency: String?
    public let learningDuration: Int? // 学习时长 单位：s
    public let coinNum: Int?    // 奖励的 token 数量 299
    public let greatSentence: [SceneCourseSentence]?
    public let needImprovedSentence: [SceneCourseSentence]?
    
    enum CodingKeys: String, CodingKey {
        case partId = "id"
        case partName
        case learningDays
        case accuracy
        case fluency
        case learningDuration
        case coinNum
        case greatSentence
        case needImprovedSentence = "needImproveSentence"
        
    }
    
}
