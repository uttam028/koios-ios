//
//  ConsentManagement.swift
//  koios
//
//  Created by Afzal Hossain on 11/19/20.
//  Copyright © 2020 Afzal Hossain. All rights reserved.
//

import Foundation
import ResearchKit
import SwiftyJSON

public struct ConsentSectionStruct {

    var sectionType:String
    var title:String
    var imageUrl:String
    var summary:String
    var learnMoreTitle:String
    var contentHtml:String
    
    static func responseFromJSONData(jsonData:JSON)->ConsentSectionStruct{
        let sectionType:String = jsonData["type"].stringValue
        let title:String = jsonData["title"].stringValue
        let imageUrl:String = jsonData["imageUrl"].stringValue
        let summary:String = jsonData["summary"].stringValue
        let learnMoreTitle:String = jsonData["learnMoreTitle"].stringValue
        let contentHtml:String = jsonData["contentHtml"].stringValue
        
        return ConsentSectionStruct(sectionType: sectionType, title: title, imageUrl: imageUrl, summary: summary, learnMoreTitle: learnMoreTitle, contentHtml: contentHtml)
    }
    
}


public class ConsentGenerator{
    static let sharedInstance = ConsentGenerator()
    
    private static func getType(type:String)->ORKConsentSectionType{
        switch type {
        case "overview":
            return .overview
        case "dataGathering":
            return .dataGathering
        case "privacy":
            return .privacy
        case "dataUse":
            return .dataUse
        case "timeCommitment":
            return .timeCommitment
        case "withdrawing":
            return .withdrawing
        case "onlyInDocument":
            return .onlyInDocument
        default:
            return .custom
        }
    }
    
    public static func getConsentDocument(listOfSections:[ConsentSectionStruct])->ORKConsentDocument{
        let consentDocument = ORKConsentDocument()
        consentDocument.title = "Consent for the Participation"

        
        consentDocument.sections = []
        
        for sectionStruct in listOfSections{
            let section = ORKConsentSection(type: getType(type: sectionStruct.sectionType))
            if !sectionStruct.title.isEmpty {
                section.title = sectionStruct.title
            }
            if !sectionStruct.summary.isEmpty{
                section.summary = sectionStruct.summary
            }
            if !sectionStruct.contentHtml.isEmpty {
                var learnMore = "Learn More"
                if !sectionStruct.learnMoreTitle.isEmpty {
                    learnMore = sectionStruct.learnMoreTitle
                }
                section.customLearnMoreButtonTitle = learnMore
                section.htmlContent = sectionStruct.contentHtml
            }
            consentDocument.sections?.append(section)
        }
//        consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
        let signature = ORKConsentSignature()
//        signature.givenName = "Afzal"
//        signature.familyName = "Hossain"
        signature.title = "Participant"
//        consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: "Mr.", dateFormatString: "yyyy-MM-dd", identifier: "ConsentDocumentParticipantSignature", givenName: "afzal", familyName: "hossain", signatureImage: nil, dateString: "date string"))
        consentDocument.addSignature(signature)
        
        let piSignature = ORKConsentSignature()
        piSignature.title = "PI"
        consentDocument.addSignature(piSignature)
        return consentDocument
    }
    
    public static func getConsentTask(listOfSections:[ConsentSectionStruct])->ORKOrderedTask{
        
        
        var steps = [ORKStep]()
        
        
        //TODO: Add VisualConsentStep
        let consentDocument = getConsentDocument(listOfSections: listOfSections)
        let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
        steps += [visualConsentStep]
        
        //TODO: Add ConsentReviewStep
//        let signature = consentDocument.signatures!.first as! ORKConsentSignature
//        signature.title = "My Signature"

        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: consentDocument.signatures?[0], in: consentDocument)
//        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: nil, in: consentDocument)
        
        reviewConsentStep.text = "Review Consent!"
        reviewConsentStep.reasonForConsent = "Consent to join study"
        
        
        steps += [reviewConsentStep]
        
        //consent share
//        let consentSharingStep = ORKConsentSharingStep(identifier: "share", investigatorShortDescription: "Investigate short description", investigatorLongDescription: "Investigate Long description", localizedLearnMoreHTMLContent: "Learn more about data share");
//
//        steps += [consentSharingStep];
        
        //Completion
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = "Welcome"
        completionStep.text = "Thank you for joining this study. The research investigator keeps the final rights to add you to the study. They will contact you via email for further instruction."
        steps += [completionStep]
        
        return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
    }
    
}


