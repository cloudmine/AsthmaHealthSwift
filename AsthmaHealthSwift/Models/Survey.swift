import ResearchKit

// MARK: Public

struct Survey {

    static func task(forInfo info: SurveyInfo) -> ORKOrderedTask? {
        switch info {
        case Daily.info:
            return Daily.Task
        default:
            return nil
        }
    }

    struct Daily {

        static let info: SurveyInfo = SurveyInfo(displayName: NSLocalizedString("Daily Survey", comment: ""),
                                                   rkIdentifier: "ACMDailySurveyTask",
                                                   frequency: .Weekly,
                                                   questionCount: 8)
    }
}

// MARK: Daily Survey Generator

private extension Survey.Daily {

    static var Task: ORKOrderedTask {
        return ORKOrderedTask(identifier: "", steps: steps)
    }

    static var steps: [ORKStep] {
        return [daytimeQuestion, nighttimeQuestion]
    }

    static var daytimeQuestion: ORKQuestionStep {
        return ORKQuestionStep(identifier: "ACMDailySurveyDaytimeQuestion",
                               title: NSLocalizedString("In the last 24 hours, did you have any daytime asthma symptoms (cough, wheeze, shortness of breath or chest tightness)?", comment: ""),
                               text: nil,
                               answer: ORKBooleanAnswerFormat())
    }

    static var nighttimeQuestion: ORKQuestionStep {
        return ORKQuestionStep(identifier: "ACMDailySurveyNighttimeQuestion",
                               title: NSLocalizedString("In the last 24 hours, did you have any nighttime waking from asthma symptoms (cough, wheeze, shortness of breath or chest tightness)?", comment: ""),
                               text: nil,
                               answer: ORKBooleanAnswerFormat())
    }
}
