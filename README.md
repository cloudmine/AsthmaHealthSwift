🚨 THIS DEMO APP IS A WORK IN PROGRESS 🚨

# AsthmaHealthSwift

A demo application that showcases the CloudMine [CMHealth iOS SDK](https://github.com/cloudmine/CMHealthSDK-iOS) interface for Apple [ResearchKit](http://researchkit.org/) used in a Swift-only project.

## Getting Started

This demo application requires [CocoaPods](https://cocoapods.org/) for dependency management.  If you don't already have it, install the `cocoapods` gem:

```
#> sudo gem install cocoapods
```

Then you can proceed to configure and build the project:

```bash
cd AsthmaHealthSwift/
cp AsthmaHealthSwift/SupportingFiles/Secrets.swift-Template AsthmaHealthSwift/SupportingFiles/Secrets.swift
pod install
open AsthmaHealthSwift.xcworkspace/
```

The project should now open and build.

## Your CloudMine Application

You will want to edit `AsthmaHealthSwift/SupportingFiles/Secrets.swift` and add your CloudMine [App ID](https://cloudmine.io/docs/#/getting_started#welcome-to-cloudmine) and [API Key](https://cloudmine.io/docs/#/data_security).

Need a [CloudMine](https://cloudmineinc.com) account?  Email our [Sales team](mailto:sales@cloudmineinc.com).
