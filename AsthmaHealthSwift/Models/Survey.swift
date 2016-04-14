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
        return [daytimeQuestion, nighttimeQuestion, inhalerQuestion, puffsQuestion]
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

    static var inhalerQuestion: ORKQuestionStep {
        return ORKQuestionStep(identifier: "ACMDailySurveyInhalerQuestion",
                               title: NSLocalizedString("Did you use your quick relief inhaler in the last 24 hours, except before exercise?", comment: ""),
                               text: nil,
                               answer: ORKBooleanAnswerFormat())
    }

    static var puffsQuestion: ORKQuestionStep {
        let format = ORKNumericAnswerFormat(style: .Integer, unit: NSLocalizedString("Puffs", comment: ""), minimum: 0, maximum: 20)

        return ORKQuestionStep(identifier: "ACMDailyPuffsQuestion",
                               title: NSLocalizedString("Except for use before exercise, how many total puffs of your quick relief medicine did you take over the past 24 hours?", comment: ""),
                               text: nil,
                               answer: format)
    }
}
