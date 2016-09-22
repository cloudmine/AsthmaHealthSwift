import CMHealth
import ResearchKit

// MARK: Public

struct Consent {

    static var Task: ORKOrderedTask {
        let document = self.document()
        let task = ORKOrderedTask(identifier: "TaskId", steps: steps(document: document))
        return task
    }
}

// MARK: Steps

private extension Consent {

    static func steps(document doc:ORKConsentDocument) -> [ORKStep] {
        return [visualStep(document: doc), sharingStep(), reviewStep(document: doc), registrationStep()]
    }

    static func visualStep(document doc:ORKConsentDocument) -> ORKVisualConsentStep {
        return ORKVisualConsentStep(identifier: "VisId", document: doc)
    }

    static func sharingStep() -> ORKConsentSharingStep {
        return ORKConsentSharingStep(identifier: "ShareId",
                                     investigatorShortDescription:  InstitutionLongName,
                                     investigatorLongDescription:   InstitutionShortName,
                                     localizedLearnMoreHTMLContent: SharingOptionText)
    }

    static func reviewStep(document doc:ORKConsentDocument) -> ORKConsentReviewStep {
        let step = ORKConsentReviewStep(identifier: "RevId", signature: doc.signatures?.first, in: doc)
        step.reasonForConsent = ConsentReason
        return step
    }

    static func registrationStep() -> ORKRegistrationStep {
        let options = ORKRegistrationStepOption.includeGivenName.union(.includeFamilyName).union(.includeGender).union(.includeDOB)

        return ORKRegistrationStep(identifier: "ACMParticipantRegistrationStep",
                                   title: NSLocalizedString("Registration", comment: ""),
                                   text: NSLocalizedString("Create an account", comment: ""),
                                   options: options)
    }
}

// MARK: Consent Document

private extension Consent {

    static func document() -> ORKConsentDocument {
        let document = ORKConsentDocument()

        document.htmlReviewContent = ReviewContent
        document.addSignature(signature)
        document.sections = sections

        return document
    }

    static var signature: ORKConsentSignature {
        return ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "SigId")
    }
}

// MARK: Consent Document Sections

private extension Consent {

    static var sections: [ORKConsentSection] {
        return [welcome, test, data, ORKConsentSection.cmh_sectionForSecureCloudMineDataStorage()]
    }

    static var welcome: ORKConsentSection {
        return section(withType: .overview, title: nil, summary: WelcomeSummary, content: WelcomeContent)
    }

    static var test: ORKConsentSection {
        return section(withType: .custom, title: TestTitle, summary: TestSummary, content: TestContent)
    }

    static var data: ORKConsentSection {
        return section(withType: .dataGathering, title: nil, summary: DataSummary, content: DataContent)
    }

    static func section(withType type:ORKConsentSectionType, title:String?, summary:String?, content:String?) -> ORKConsentSection {
        let section = ORKConsentSection(type: type)
        section.title = title
        section.summary = summary
        section.content = content
        return section
    }
}

// MARK: Localized Strings

private extension Consent {

    static let ReviewContent = NSLocalizedString("ACHConsentReviewContent", comment:"")
    static let ConsentReason = NSLocalizedString("ACMConsentTaskReason", comment: "");

    static let InstitutionShortName = NSLocalizedString("ACMInstitutionNameShortText", comment: "")
    static let InstitutionLongName  = NSLocalizedString("ACMInstitutionNameLongText", comment: "")
    static let SharingOptionText    = NSLocalizedString("ACMConsentTaskSharingOptionText", comment: "")

    static let WelcomeSummary = NSLocalizedString("ACHConsentSectionWelcomeSummary", comment: "")
    static let WelcomeContent = NSLocalizedString("ACHConsentSectionWelcomeContent", comment: "")

    static let TestTitle    = NSLocalizedString("ACHConsentSectionTestTitle", comment: "")
    static let TestSummary  = NSLocalizedString("ACHConsentSectionTestSummary", comment: "")
    static let TestContent  = NSLocalizedString("ACHConsentSectionTestContent", comment: "")

    static let DataSummary  = NSLocalizedString("ACHConsentSectionDataSummary", comment: "")
    static let DataContent  = NSLocalizedString("ACHConsentSectionDataContent", comment: "")
}
