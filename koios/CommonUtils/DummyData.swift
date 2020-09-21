//
//  DummyDataJohn.swift
//  cimonv2
//
//  Created by Afzal Hossain on 2/19/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import Foundation


class DummyData: NSObject {
    
    static func getDummyTask(studyId:Int, surveyId:Int)->[Task]{
        
        /*
        let task1 = Task(studyId: 1, surveyId: 1, taskId: 1, text: "Your name", type: "text", possibleInput: "", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")
        
        let task2 = Task(studyId: 1, surveyId: 1, taskId: 2, text: "Your birthday", type: "date", possibleInput: "", orderId: 2, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")
        let task3 = Task(studyId: 1, surveyId: 1, taskId: 3, text: "Where are you from?", type: "selection", possibleInput: "North America|South America|Europe|Australia|Asia|Africa", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")
        
        let task4 = Task(studyId: 1, surveyId: 1, taskId: 3, text: "Your favorite food.", type: "choice", possibleInput: "Steak|Pizza|Salad|Taco|Spicy|Noodles", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")
        
        let task5 = Task(studyId: 1, surveyId: 1, taskId: 1, text: "What is your impression on grad school?", type: "textarea", possibleInput: "", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")

        
        
        let task11 = Task(studyId: 1, surveyId: 1, taskId: 3, text: "Are you a native English speaker?", type: "selection", possibleInput: "Yes|No", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")

        let task12 = Task(studyId: 1, surveyId: 1, taskId: 3, text: "Do you have any problem with speech?", type: "selection", possibleInput: "Yes|No", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")

        let task13 = Task(studyId: 1, surveyId: 1, taskId: 3, text: "Are you diagnosed with any of the following", type: "choice", possibleInput: "Parkinson|Damentia|Alzheimar|Stroke", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")

        let task14 = Task(studyId: 1, surveyId: 3, taskId: 1, text: "", type: "MT001", possibleInput: "", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")

        let task15 = Task(studyId: 1, surveyId: 1, taskId: 2, text: "Your last visit to doctor", type: "date", possibleInput: "", orderId: 2, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")
        let task16 = Task(studyId: 1, surveyId: 1, taskId: 1, text: "Any comment on the study", type: "textarea", possibleInput: "", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")


        
        
        
        let task21 = Task(studyId: 1, surveyId: 3, taskId: 1, text: "", type: "MT001", possibleInput: "", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")
        
        let task22 = Task(studyId: 1, surveyId: 3, taskId: 2, text: "", type: "MT002", possibleInput: "", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")
        
        let task23 = Task(studyId: 1, surveyId: 3, taskId: 3, text: "", type: "MT003", possibleInput: "", orderId: 1, isActive: 1, isRequired: 0, parentTaskId: 0, hasChild: 0, childTriggeringInput: "", defaultInput: "")

        
        if (studyId==1 && surveyId==1) {
            return [task1, task2, task3, task4, task5]
        } else if(studyId==1 && surveyId==2){
            return [task11, task12, task13, task14, task15, task16]
        } else if(studyId==1 && surveyId==3){
            return [task21, task22, task23]
        }*/
        return []
    }
    
    static func getDummySurveys()->[Survey]{
        
        
        
        
        /*
         //trace shapes with speech
         let task3 = Task(id: 3, text: "", type: "MT003", possibleInput: "", orderId: 3, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //trace shapes with cognitive load
         let task4 = Task(id: 4, text: "", type: "MT004", possibleInput: "", orderId: 4, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //gross trace shapes
         let task5 = Task(id: 5, text: "", type: "MT005", possibleInput: "", orderId: 5, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //gross trace shapes with speech
         let task6 = Task(id: 6, text: "", type: "MT006", possibleInput: "", orderId: 6, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //gross trace shapes with cognitive load
         let task7 = Task(id: 7, text: "", type: "MT007", possibleInput: "", orderId: 7, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //memory game
         let task8 = Task(id: 8, text: "", type: "MT008", possibleInput: "", orderId: 8, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //falling ball
         let task9 = Task(id: 9, text: "", type: "MT009", possibleInput: "", orderId: 9, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //target
         let task10 = Task(id: 10, text: "", type: "MT010", possibleInput: "", orderId: 10, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //viospatial
         let task11 = Task(id: 11, text: "", type: "MT011", possibleInput: "", orderId: 11, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //color
         let task12 = Task(id: 12, text: "", type: "MT012", possibleInput: "", orderId: 12, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //picture
         let task13 = Task(id: 13, text: "", type: "MT013", possibleInput: "", orderId: 13, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //balance
         let task14 = Task(id: 14, text: "", type: "MT014", possibleInput: "", orderId: 14, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         //connect the dots
         let task15 = Task(id: 15, text: "", type: "MT015", possibleInput: "", orderId: 15, isActive: 1, isRequired: 0, parentTaskId: -1, hasChild: 0, inputToTriggerChild: "", defaultInput: "")
         
         */
        
        /*
        //survey 1
        let survey1 = Survey(surveyId: 1, studyId: 1, name: "Introduce Yourself", description: "Graduate School Survey", startTime: "", startTimeZone: "", endTime: "", endTimeZone: "", scheduleCode: "")
        
        //Survey 2
        let survey2 = Survey(surveyId: 2, studyId: 1, name: "Questions & Motor Task", description: "mHealth study 2019", startTime: "", startTimeZone: "", endTime: "", endTimeZone: "", scheduleCode: "")
        
        let survey3 = Survey(surveyId: 3, studyId: 1, name: "A set of motor task", description: "mHealth study 2019", startTime: "", startTimeZone: "", endTime: "", endTimeZone: "", scheduleCode: "")

        //case 1: one survey, show survey 1
        return [survey1, survey2, survey3]
        */
        
        //case 2: one survey, show survey 2
        //return [survey2]
        
        //case 3: two surveys, show both
        //return [survey1, survey2]
        
        return []
    }
    
    static func getNotifications()->[String]{
        return ["This is first message", "This is second message", "This is third message", "This is fourth message",
                "This is 1st message", "This is 2nd message", "This is 3rd message", "This is 4th message"]
    }

    
}






