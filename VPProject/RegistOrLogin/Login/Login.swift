//
//  Login.swift
//  SWBaseModels
//
//  Created by Zacharyah on 2023/3/6.
//

import Foundation

// doc https://ztwgw5unb5.feishu.cn/wiki/wikcnK7JnXIjpYm3x7y9SS5donM

// MARK: 支持母语 model
public struct LanguageInfo: Codable {
    
    public let langCode: String?     // 语言码
    public let countryFlag: String?   // 国旗
    public let localLanguage: String? // 语言描述（本地语言）
    public var isSelected:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case langCode
        case countryFlag
        case localLanguage
    }
    
}

public struct LangeuageResponse:Decodable {
    let code:Int?
    let msg:String?
    let localMsg:String?
    let data:[LanguageInfo]?
}

// MARK: 获取注册的问卷、欢迎语

public enum QuestionType: String, Codable {
    case conversion = "CONVERSION"  // 问卷前对话
    case purpose = "PURPOSE"        // 学习目的
    case level = "LEVEL"            // 学习级别
}

// conversionInfo 与 questionnaire 共用
public struct QuestionItem: Decodable {
    
    public let qosCode: String?
    public let targetDefinition: String?
    public let englishDefinition: String?
    
    enum CodingKeys: String, CodingKey {
        case qosCode
        case targetDefinition
        case englishDefinition
    }
    
}

public struct GreetingResponse:Decodable {
    let code:Int?
    let msg:String?
    let localMsg:String?
    let data:[QuestionItem]?
}

public struct Question: Decodable {
    
    public let type: QuestionType?
    public let targetDefinition: String?
    public let items: [QuestionItem]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case targetDefinition   
        case items
    }
    
}

// MARK: 注册 model

public struct SignupQuestionItem: Codable {
    public let qosCode: String?
    public let type: QuestionType?
    
    enum CodingKeys: String, CodingKey {
        case type
        case qosCode
    }
    
}

public struct SignupModel: Codable {
    public let invitationCode: String?
    public let email: String?
    public let password: String?
    public let motherTongue: String? // 注册母语
    public let questionnaire: [SignupQuestionItem]?
    
    enum CodingKeys: String, CodingKey {
        case invitationCode
        case email
        case password
        case motherTongue
        case questionnaire
    }
    
}

// MARK: 登录 response
public struct SigninResponse: Decodable {
    public let userId: String?
    public let motherTongue: String?
    public let registerLevel: String?
    public let registerPurpose: String?
    public let registNextStep: String?
    public let token: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case motherTongue
        case registerLevel
        case registerPurpose
        case registNextStep
        case token
    }
}

public struct LoginResponse: Decodable {
    let code:Int?
    let msg:String?
    let localMsg:String?
    let data:SigninResponse?
}

public enum RoleSex: Int, Codable {
    case female = 0
    case male
}

public enum RecommendType: Int, Codable {
    case none = 0
    case recommend
}

public struct RoleTag: Decodable {
    public let tagId: Int?
    public let tagName: String?
    
    enum CodingKeys: String, CodingKey {
        case tagId
        case tagName
    }
    
}

// MARK: 获取角色
public struct ScenarioRole: Decodable {
    
    public let headImage: String?
    public let roleName: String?
    public let age: Double?
    public let sex: RoleSex?
    public let nature: String?      // 性格
    public let keyword: String?     // 关键词
    public let seasonId: String?
    public let seasonName: String?
    public let recommend: RecommendType?   // 是否推荐(1:是；0：否)
    public let tagList: [RoleTag]?
    
    enum CodingKeys: String, CodingKey {
        case headImage
        case roleName
        case age
        case sex
        case nature
        case keyword
        case seasonId
        case seasonName
        case recommend
        case tagList
    }
    
}
