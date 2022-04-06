//
//  InterestUpdate.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 24/03/2022.
//

import Foundation

struct InterestUpdate: Codable {
    var recordNo: Int?
    var studentInterest, studyExpectingYear, subject, studyDestination: String?
    var isIELTS, isTOEFL, isTOEIC, isUMAT, isGED, isUKCAT, isGCE, isSAT, isACT, isGAMSAT, isLSAT, isMAT, isGRE, isGMAT, isMCAT, isDAT, isOAT, isPCAT, isTEAS, isAHPAT: Bool?
    var currentEducation, currentInstitution, currentProgramme, averageScore, intendingToWork, isGottenAJob, careerPath, isCertificationToWork, relocation, isEligibleForRelocation, isNeedConsultation, createdOn: String?
    var tef, wes, ices, iqas, pebc, ces, icas, mcc: Bool?
    var twoOrMoreDegrees, whatIsYourFamilySize, whatIsJobTitle: String?
    var interestFk, studentFk, yearsOfExperience: Int?
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case recordNo = "RecordNo"
        case studentInterest = "StudentInterest"
        case studyExpectingYear = "StudyExpectingYear"
        case subject = "Subject"
        case studyDestination = "StudyDestination"
        case isIELTS = "IsIELTS"
        case isTOEFL = "IsTOEFL"
        case isTOEIC = "IsTOEIC"
        case isUMAT = "IsUMAT"
        case isGED = "IsGED"
        case isUKCAT = "IsUKCAT"
        case isGCE = "IsGCE"
        case isSAT = "IsSAT"
        case isACT = "IsACT"
        case isGAMSAT = "IsGAMSAT"
        case isLSAT = "IsLSAT"
        case isMAT = "IsMAT"
        case isGRE = "IsGRE"
        case isGMAT = "IsGMAT"
        case isMCAT = "IsMCAT"
        case isDAT = "IsDAT"
        case isOAT = "IsOAT"
        case isPCAT = "IsPCAT"
        case isTEAS = "IsTEAS"
        case isAHPAT = "IsAHPAT"
        case currentEducation = "CurrentEducation"
        case currentInstitution = "CurrentInstitution"
        case currentProgramme = "CurrentProgramme"
        case averageScore = "AverageScore"
        case intendingToWork = "IntendingToWork"
        case isGottenAJob = "IsGottenAJob"
        case careerPath = "CareerPath"
        case isCertificationToWork = "IsCertificationToWork"
        case relocation = "Relocation"
        case isEligibleForRelocation = "IsEligibleForRelocation"
        case isNeedConsultation = "IsNeedConsultation"
        case createdOn = "CreatedOn"
        case tef = "TEF"
        case wes = "WES"
        case ices = "ICES"
        case iqas = "IQAS"
        case pebc = "PEBC"
        case ces = "CES"
        case icas = "ICAS"
        case mcc = "MCC"
        case interestFk = "InterestFk"
        case studentFk = "StudentFk"
        case yearsOfExperience = "YearsOfExperience"
        case twoOrMoreDegrees = "TwoOrMoreDegrees"
        case whatIsYourFamilySize = "WhatIsYourFamilySize"
        case whatIsJobTitle = "WhatIsJobTitle"
    }
}
