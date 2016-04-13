import Foundation

enum SurveyFrequency {
    case Daily, Weekly
}

struct SurveyInfo {
    let displayName: String
    let rkIdentifier: String
    let frequency: SurveyFrequency
    let questionCount: Int
}
