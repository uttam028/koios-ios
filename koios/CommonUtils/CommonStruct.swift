//
//  CommonStruct.swift
//  cimonv2
//
//  Created by Afzal Hossain on 2/13/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: service structs
struct Response {
    var code:Int
    var message:String

    static func responseFromJSONData(jsonData:JSON)->Response{
        let code = jsonData["code"].intValue
        let message = jsonData["message"].stringValue
        
        return Response(code: code, message: message)
    }
    
}

// MARK: general structs
struct LabelStruct {
    var imageName:String
    var labelText:String
}

// MARK: core data structs

struct StudyStruct{
    var studyId:Int32
    var name:String
    var studyDescription:String?
    var instruction:String?
    var modificationTime:String?
    var state:Int16
    var iconUrl:String?
    
    static func responseFromJSONData(jsonData:JSON)->StudyStruct{
        let studyId = Int32(jsonData["id"].intValue)
        let name = jsonData["name"].stringValue
        let studyDescription = jsonData["description"].stringValue
        let instruction = jsonData["instruction"].stringValue
        let modificationTime = jsonData["modificationTime"].stringValue
        let state = Int16(jsonData["state"].intValue)
        let iconUrl = jsonData["iconUrl"].stringValue

        return StudyStruct(studyId: studyId, name: name, studyDescription: studyDescription, instruction: instruction, modificationTime: modificationTime, state: state, iconUrl: iconUrl)
    }

}

struct SurveyResponseStruct{
    var studyId:Int32
    var surveyId:Int32
    var taskId:Int16
    var version:Int16
    var submissionTime:String
    var submissionTimeZone:String
    var answerType:String
    var answer:String
    var comment:String
    var objectUrl:String
}


struct AppNotificationStruct{
    var notificationId:Int64
    var originatedSource:String
    var originatedTime: String
    var title:String
    var message:String
    var loadingTime:String
    var loadingTimeZone:String
    var deleteOnView:Int16
    var expiry:Int32
    var viewCount:Int32
}

/*
struct TaskStruct{
    var studyId:Int
    var surveyId:Int
    var taskId:Int
    var text:String
    var type:String
    var possibleInput:String
    var orderId:Int
    var isActive:Int
    var isRequired:Int
    var parentTaskId:Int
    var hasChild:Int
    var childTriggeringInput:String
    var defaultInput:String
    
    static func taskStructFromManagedObject(task:Task)->TaskStruct{
        let studyId:Int = Int(task.studyId)
        let surveyId:Int = Int(task.surveyId)
        let taskId:Int = Int(task.taskId)
        let text:String = task.text!
        let type:String = task.type!
        let possibleInput:String = task.possibleInput!
        let orderId:Int = Int(task.orderId)
        let isActive:Int = Int(task.isActive)
        let isRequired:Int = Int(task.isRequired)
        let parentTaskId:Int = Int(task.parentTaskId)
        let hasChild:Int = Int(task.hasChild)
        let childTriggeringInput:String = task.childTriggeringInput!
        let defaultInput:String = task.defaultInput!

        return TaskStruct(studyId: studyId, surveyId: surveyId, taskId: taskId, text: text, type: type, possibleInput: possibleInput, orderId: orderId, isActive: isActive, isRequired: isRequired, parentTaskId: parentTaskId, hasChild: hasChild, childTriggeringInput: childTriggeringInput, defaultInput: defaultInput)
    }
}

struct SurveyStruct {
    var studyId:Int
    var surveyId:Int
    var name:String
    var description:String
    var publishTime:String
    var publisheVersion:Int
    var startTime:String
    var endTime:String
    var cycleStartTime:String
    var cycleEndTime:String
    var cycleIdentifier:String
    var scheduleCode:String
    var notified:Int
    var participated:Int
    var totalParticipation:Int
    
    static func surveyStructFromManagedObject(survey:Survey)->SurveyStruct{
        let studyId:Int = Int(survey.studyId)
        let surveyId:Int = Int(survey.surveyId)
        let name:String = survey.name!
        let description:String = survey.surveyDesc ?? ""
        let publishTime:String = survey.publishTime!
        let publisheVersion:Int = Int(survey.version)
        let startTime:String = survey.startTime!
        let endTime:String = survey.endTime!
        let cycleStartTime:String = survey.cycleStartTime ?? ""
        let cycleEndTime:String = survey.cycleEndTime ?? ""
        let cycleIdentifier:String = survey.cycleIdentifier ?? ""
        let scheduleCode:String = survey.scheduleCode ?? ""
        let notified:Int = Int(survey.notified)
        let participated:Int = Int(survey.participated)
        let totalParticipation:Int = Int(survey.totalParticipation)

        return SurveyStruct(studyId: studyId, surveyId: surveyId, name: name, description: description, publishTime: publishTime, publisheVersion: publisheVersion, startTime: startTime, endTime: endTime, cycleStartTime: cycleStartTime, cycleEndTime: cycleEndTime, cycleIdentifier: cycleIdentifier, scheduleCode: scheduleCode, notified: notified, participated: participated, totalParticipation: totalParticipation)
    }
}
*/

/*
struct Task{
    var studyId:Int
    var surveyId:Int
    var taskId:Int
    var text:String
    var type:String
    var possibleInput:String
    var orderId:Int
    var isActive:Int
    var isRequired:Int
    var parentTaskId:Int
    var hasChild:Int
    var childTriggeringInput:String
    var defaultInput:String
}

struct Survey {
    var surveyId:Int
    var studyId:Int
    var name:String
    var description:String
    var startTime:String
    var startTimeZone:String
    var endTime:String
    var endTimeZone:String
    var scheduleCode:String
}


struct ActiveSurvey {
    
}
*/
