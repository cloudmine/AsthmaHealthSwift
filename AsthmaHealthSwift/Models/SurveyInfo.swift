import Foundation

enum SurveyFrequency {
    case oneTime, daily
}

struct SurveyInfo {
    let displayName: String
    let rkIdentifier: String
    let frequency: SurveyFrequency
    let questionCount: Int
}

extension SurveyInfo : Equatable { }

func ==(lhs: SurveyInfo, rhs: SurveyInfo) -> Bool {
    return lhs.displayName == rhs.displayName &&
        lhs.rkIdentifier == rhs.rkIdentifier &&
        lhs.frequency == rhs.frequency &&
        lhs.questionCount == rhs.questionCount
}
