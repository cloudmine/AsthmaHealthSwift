import ResearchKit

typealias TextQuestionChoice = (text: String, keyword: String, exclusive: Bool)

// MARK: Public

struct Survey {

    static func task(forInfo info: SurveyInfo) -> ORKOrderedTask? {
        switch info {
        case Daily.info:
            return Daily.Task
        case About.info:
            return About.Task
        default:
            return nil
        }
    }

    struct About {

        static let info: SurveyInfo = SurveyInfo(displayName: NSLocalizedString("About You", comment: ""),
                                                 rkIdentifier: "ACMAboutYouSurveyTask",
                                                 frequency: .OneTime,
                                                 questionCount: 8)
    }

    struct Daily {

        static let info: SurveyInfo = SurveyInfo(displayName: NSLocalizedString("Daily Survey", comment: ""),
                                                   rkIdentifier: "ACMDailySurveyTask",
                                                   frequency: .Daily,
                                                   questionCount: 8)
    }
}

// MARK: Generic Question Generators

private extension Survey {

    static func textQuestion(withTitle title: String, surveyId sId: String, questionId qId: String, choiceInfo: [TextQuestionChoice]) -> ORKQuestionStep  {
        let choices = choiceInfo.map { choice in
            ORKTextChoice(text: choice.text, detailText: nil, value: "ACM\(qId)\(choice.keyword)Choice", exclusive: choice.exclusive)
        }

        let allExclusive = choiceInfo.reduce(true) { (acc, info) in acc && info.exclusive }
        let style = allExclusive ? ORKChoiceAnswerStyle.SingleChoice : .MultipleChoice

        let format = ORKTextChoiceAnswerFormat(style: style, textChoices: choices)
        return ORKQuestionStep(identifier: "ACM\(sId)Survey\(qId)Question", title: title, text: nil, answer: format)
    }
}

// MARK: About You Survey Generator

private extension Survey.About {

    static var Task: ORKOrderedTask {
        return ORKOrderedTask(identifier: info.rkIdentifier, steps: steps)
    }

    static var steps: [ORKStep] {
        return [ethnicityQuestion, raceQuestion, incomeQuestion, educationQuestion,
                smokingQuestion, cigarettesQuestion, yearsQuestion, insuranceQuestion]
    }

    static var ethnicityQuestion: ORKQuestionStep {
        return Survey.textQuestion(withTitle: ethnicityTitle, surveyId: surveyId, questionId: ethnicityQId, choiceInfo: ethnicityChoices)
    }

    static var raceQuestion: ORKQuestionStep {
        return Survey.textQuestion(withTitle: raceTitle, surveyId: surveyId, questionId: raceQId, choiceInfo: raceChoices)
    }

    static var incomeQuestion: ORKQuestionStep {
        return Survey.textQuestion(withTitle: incomeTitle, surveyId: surveyId, questionId: incomeQId, choiceInfo: incomChoices)
    }

    static var educationQuestion: ORKQuestionStep {
        return Survey.textQuestion(withTitle: educationTitle, surveyId: surveyId, questionId: educationQId, choiceInfo: educationChoices)
    }

    static var smokingQuestion: ORKQuestionStep {
        return Survey.textQuestion(withTitle: smokingTitle, surveyId: surveyId, questionId: smokingQId, choiceInfo: smokingChoices)
    }

    static var cigarettesQuestion: ORKQuestionStep {
        let format = ORKNumericAnswerFormat(style: .Integer, unit: NSLocalizedString("Cigarettes", comment: ""), minimum: 1, maximum: 200)

        return ORKQuestionStep(identifier: "ACMAboutYouSurveyCigarettesQuestion",
                               title: NSLocalizedString("On average, how many cigarettes per day did you smoke daily?", comment: ""),
                               answer: format)
    }

    static var yearsQuestion: ORKQuestionStep {
        let format = ORKNumericAnswerFormat(style: .Integer, unit: NSLocalizedString("Years", comment: ""), minimum: 0, maximum: 100)

        return ORKQuestionStep(identifier: "ACMAboutYouSurveyYearsSmokingQuestion",
                               title: NSLocalizedString("How many years in total did you smoke?", comment: ""),
                               answer: format)
    }

    static var insuranceQuestion: ORKQuestionStep {
        return Survey.textQuestion(withTitle: insuranceTitle, surveyId: surveyId, questionId: insuranceQId, choiceInfo: insuranceChoices)
    }
}

// MARK: About You Survey Strings

private extension Survey.About {

    static let surveyId = "AboutYou"

    static func noAnswerChoice(forQuestionId qId: String) -> TextQuestionChoice {
        return (NSLocalizedString("I choose not to answer", comment:""), "ACM\(qId)ChooseNotToAnswerChoice", true)
    }

    static let ethnicityTitle = NSLocalizedString("Ethnicity", comment: "")
    static let ethnicityQId = "Ethnicity"
    static let ethnicityChoices: [TextQuestionChoice] = [
            (NSLocalizedString("Hispanic/Latino", comment: ""), "HispanicLatino", true),
            (NSLocalizedString("Non-Hispanic/Latino", comment: ""), "NonHispanicLatino", true),
            Survey.About.noAnswerChoice(forQuestionId: Survey.About.ethnicityQId)
        ]

    static let raceTitle = NSLocalizedString("Race (Check all that apply)", comment: "")
    static let raceQId = "Race"
    static let raceChoices: [TextQuestionChoice] = [
            (NSLocalizedString("Black/African American", comment: ""), "Black", false),
            (NSLocalizedString("Asian", comment: ""), "Asian", false),
            (NSLocalizedString("American Indian or Alaskan Native", comment: ""), "NativeAmerican", false),
            (NSLocalizedString("Hawaiian or other Pacific Islander", comment: ""), "PacificIslander", false),
            (NSLocalizedString("White", comment: ""), "White", false),
            (NSLocalizedString("Other", comment: ""), "Other", false),
            Survey.About.noAnswerChoice(forQuestionId: Survey.About.raceQId)
        ]

    static let incomeTitle = NSLocalizedString("Which of the following best describes the total annual income of all members of your household?", comment: "")
    static let incomeQId = "Income"
    static let incomChoices: [TextQuestionChoice] = [
            (NSLocalizedString("<$14,999", comment: ""), "Tier1", true),
            (NSLocalizedString("$15,000-21,999", comment: ""), "Tier2", true),
            (NSLocalizedString("$22,000-43,999", comment: ""), "Tier3", true),
            (NSLocalizedString("$44,000-60,000", comment: ""), "Tier4", true),
            (NSLocalizedString(">$60,000", comment: ""), "Tier5", true),
            (NSLocalizedString("I don't know", comment: ""), "DoNotKnow", true),
            Survey.About.noAnswerChoice(forQuestionId: Survey.About.incomeQId)
        ]

    static let educationTitle = NSLocalizedString("What is the highest level of education you have completed?", comment: "")
    static let educationQId = "Education"
    static let educationChoices: [TextQuestionChoice] = [
            (NSLocalizedString("8th Grade or Less", comment: ""), "NoHighSchool", true),
            (NSLocalizedString("More than 8th grade but did not graduate high school", comment: ""), "SomeHighSchool", true),
            (NSLocalizedString("High school graduate or equivalent", comment: ""), "HighSchool", true),
            (NSLocalizedString("Some College", comment: ""), "SomeCollege", true),
            (NSLocalizedString("Graduate of Two Year College or Technical School", comment: ""), "TwoYearCollege", true),
            (NSLocalizedString("Graduate of Four Year College", comment: ""), "FourYearCollege", true),
            (NSLocalizedString("Post Graduate Studies", comment: ""), "PostGrad", true),
            Survey.About.noAnswerChoice(forQuestionId: Survey.About.educationTitle)
        ]

    static let smokingTitle = NSLocalizedString("What is your smoking status?", comment: "")
    static let smokingQId = "Smoking"
    static let smokingChoices: [TextQuestionChoice] = [
            (NSLocalizedString("Never (<100 Cigarettes in lieftime)", comment: ""), "Never", true),
            (NSLocalizedString("Current", comment: ""), "Current", true),
            (NSLocalizedString("Former", comment: ""), "Former", true),
        ]

    static let insuranceTitle = NSLocalizedString("Do you have health insurance?", comment: "")
    static let insuranceQId = "Insurance"
    static let insuranceChoices: [TextQuestionChoice] = [
            (NSLocalizedString("Private (bought by you or your employer", comment: ""), "Private", true),
            (NSLocalizedString("Public (Medicare or Medicade", comment: ""), "Public", true),
            (NSLocalizedString("I have no health insurance", comment: ""), "NoInsurance", true),
            Survey.About.noAnswerChoice(forQuestionId: Survey.About.insuranceQId)
        ]
}

// MARK: Daily Survey Generator

private extension Survey.Daily {

    static var Task: ORKOrderedTask {
        return ORKOrderedTask(identifier: info.rkIdentifier, steps: steps)
    }

    static var steps: [ORKStep] {
        return [daytimeQuestion, nighttimeQuestion, inhalerQuestion, puffsQuestion, causesQuestion, flowQuestion, medicineQuestion]
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

    static var flowQuestion: ORKQuestionStep {
        let format = ORKNumericAnswerFormat(style: .Integer, unit: NSLocalizedString("L/min", comment: ""), minimum: 60, maximum: 900)

        return ORKQuestionStep(identifier: "ACMDailyPeaksQuestion",
                               title: NSLocalizedString("Enter your peak flow today? (L/min)", comment: ""),
                               text: nil,
                               answer: format)
    }

    static var medicineQuestion: ORKQuestionStep {
        return Survey.textQuestion(withTitle: medicineTitle, surveyId: surveyId, questionId: "Medicine", choiceInfo: medicineChoices)
    }
}

// MARK: Daily Survey Strings

private extension Survey.Daily {

    static let surveyId = "Daily"

    static let causesTitle = NSLocalizedString("Did any of the following cause your asthma to get worse today? (check all that apply):", comment: "")
    static let causesChoices: [TextQuestionChoice] = [
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

    static let medicineTitle = NSLocalizedString("Did you take your asthma control medicine in the last 24 hours?", comment: "")
    static let medicineChoices: [TextQuestionChoice] = [
            (NSLocalizedString("Yes, all of my prescribed doses", comment: ""), "YesAllDoses", true),
            (NSLocalizedString("Yes, some but not all of my prescribed doses", comment: ""), "YesNotAllDoses", true),
            (NSLocalizedString("No, I did not take them", comment: ""), "No", true),
            (NSLocalizedString("I'm not sure", comment: ""), "NotSure", true),
        ]
}
