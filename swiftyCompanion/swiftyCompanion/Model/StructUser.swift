//
//  StructUser.swift
//  swiftyCompanion
//
//  Created by Миша on 16.09.2021.
//

import Foundation

struct User: Decodable {
    
    let email: String
    let login: String
    let userFullName: String
    let imageUrl: String
    let stuff: Bool
    let correctionPoint: Int
    let location: String?
    let wallet: Int
    
    let cursusUsers: [Cursus]
    let prjectsUsers: [Project]
    let titleUsers: [Title]
    let titleUserId: [TitleId]
    let campus: [Campus]
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case login = "login"
        case userFullName = "usual_full_name"
        case imageUrl = "image_url"
        case stuff = "staff?"
        case correctionPoint = "correction_point"
        case location = "location"
        case wallet = "wallet"
        
        case cursusUsers = "cursus_users"
        case prjectsUsers = "projects_users"
        case titleUsers = "titles"
        case titleUserId = "titles_users"
        case campus = "campus"
    }
}

struct Cursus: Decodable {
    let level: Double
    let skills: [Skills]
    let curcusName: CurcusName
    
    enum CodingKeys: String, CodingKey {
        case level = "level"
        case skills = "skills"
        case curcusName = "cursus"
    }
}

struct Skills: Decodable {
    let nameSkills: String
    let lavelSlills: Double
    
    enum CodingKeys: String, CodingKey {
        case nameSkills = "name"
        case lavelSlills = "level"
    }
}

struct CurcusName: Decodable {
    let id: Int
    let nameCurcus: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nameCurcus = "name"
    }
}

struct Title: Decodable {
    let nameTitle: String
    
    enum CodingKeys: String, CodingKey {
        case nameTitle = "name"
    }
}

struct TitleId: Decodable {
    let selectTitle: Bool
    
    enum CodingKeys: String, CodingKey {
        case selectTitle = "selected"
    }
}

struct Project: Decodable {
    let finalMark: Int?
    let status: String
    let validated: Bool?
    let projectName: ProjectName
    let curses_id: [Int]
    
    enum CodingKeys: String, CodingKey {
        case finalMark = "final_mark"
        case status = "status"
        case validated = "validated?"
        case projectName = "project"
        case curses_id = "cursus_ids"
    }
}

struct ProjectName: Decodable {
    let name: String
    let parentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case parentId = "parent_id"
    }
}

struct Campus: Decodable {
    let city: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case country = "country"
   }
}
