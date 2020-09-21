//
//  StringUtils.swift
//  cimonv2
//
//  Created by Afzal Hossain on 2/13/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import Foundation


extension String
{
    var length: Int {
        get {
            return self.count
        }
    }
    
    func contains(s: String) -> Bool{
        return (self.range(of: s) != nil) ? true : false
    }

    func replaceAll(target: String, withString: String) -> String{
        return self.replacingOccurrences(of: target, with: withString, options: .literal, range: nil)
    }
    
    func trim()->String{
        let trimmed =  self.trimmingCharacters(in: .whitespaces)
        return trimmed
    }
    
}

extension SurveyResponse:Encodable{
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(studyId, forKey: .studyId)
        try container.encode(surveyId, forKey: .surveyId)
        try container.encode(taskId, forKey: .taskId)
        try container.encode(version, forKey: .version)
        try container.encode(submissionTime, forKey: .submissionTime)
        try container.encode(submissionTimeZone, forKey: .submissionTimeZone)
        try container.encode(answer, forKey: .answer)
        try container.encode(answerType, forKey: .answerType)
        try container.encode(comment, forKey: .comment)
        try container.encode(objectUrl, forKey: .objectUrl)
    }
    
    enum CodingKeys: String, CodingKey {
        case studyId
        case surveyId
        case taskId
        case version
        case submissionTime
        case submissionTimeZone
        case answer
        case answerType
        case comment
        case objectUrl
    }
}



extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
