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

// MARK: Generic Question Generators

private extension Survey {

    static func textQuestion(withTitle title: String, surveyId sId: String, questionId qId: String, choiceInfo: [(String, String, Bool)]) -> ORKQuestionStep  {
        let choices = choiceInfo.map { (text, keyword, isExclusive) in
            ORKTextChoice(text: text, detailText: nil, value: "ACM\(qId)\(keyword)Choice", exclusive: isExclusive)
        }

        let allExclusive = choiceInfo.reduce(true) { (acc, info) in acc && info.2 }
        let style = allExclusive ? ORKChoiceAnswerStyle.SingleChoice : .MultipleChoice

        let format = ORKTextChoiceAnswerFormat(style: style, textChoices: choices)
        return ORKQuestionStep(identifier: "ACM\(sId)Survey\(qId)Question", title: title, text: nil, answer: format)
    }
}

// MARK: Daily Survey Generator

private extension Survey.Daily {

    static var Task: ORKOrderedTask {
        return ORKOrderedTask(identifier: "", steps: steps)
    }

    static var steps: [ORKStep] {
        return [daytimeQuestion, nighttimeQuestion, inhalerQuestion, puffsQuestion, causesQuestion]
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

    static var causesQuestion: ORKQuestionStep {
        return Survey.textQuestion(withTitle: causesTitle, surveyId: surveyId, questionId: "Causes", choiceInfo: causesChoices)
    }
}

// MARK: Daily Survey Strings

private extension Survey.Daily {
    static let surveyId = "Daily"

    static let causesTitle = NSLocalizedString("Did any of the following cause your asthma to get worse today? (check all that apply):", comment: "")
    static var causesChoices: [(String, String, Bool)] {
        return [
            (NSLocalizedString("A Cold", comment: ""), "Cold", false),
            (NSLocalizedString("Exercise", comment: ""), "Exercise", false),
            (NSLocalizedString("Being more active than usual (walking, running, climbing stairs)", comment: ""), "Activity", false),
            (NSLocalizedString("Strong smells (perfume, chemicals, sprays, paint)", comment: ""), "Smells", false),
            (NSLocalizedString("Exhaust fumes", comment: ""), "Exhaust", false),
            (NSLocalizedString("House dust", comment: ""), "Dust", false),
            (NSLocalizedString("Dogs", comment: ""), "Dogs", false),
            (NSLocalizedString("Cats", comment: ""), "Cats", false),
            (NSLocalizedString("Other furry/feathered animals", comment: ""), "OtherAnimals", false),
            (NSLocalizedString("Mold", comment: ""), "Mold", false),
            (NSLocalizedString("Pollen from trees, grass or weeds", comment: ""), "Pollen", false),
            (NSLocalizedString("Extreme heat", comment: ""), "Heat", false),
            (NSLocalizedString("Extreme cold", comment: ""), "Cold", false),
            (NSLocalizedString("Changes in weather", comment: ""), "Weather", false),
            (NSLocalizedString("Around the time of my period", comment: ""), "Period", false),
            (NSLocalizedString("Poor air quality", comment: ""), "AirQuality", false),
            (NSLocalizedString("Someone smoking near me", comment: ""), "Smoke", false),
            (NSLocalizedString("Stress", comment: ""), "Stress", false),
            (NSLocalizedString("Feeling sad, angry, excited, tense", comment: ""), "Emotion", false),
            (NSLocalizedString("Laughter", comment: ""), "Laughter", false),
            (NSLocalizedString("I don't know what triggers my asthma", comment: ""), "DoNotKnow", true),
            (NSLocalizedString("None of these things trigger my asthma", comment: ""), "None", true),
        ]
    }
}
