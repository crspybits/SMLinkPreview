# URL Link Preview

[![Version](https://img.shields.io/cocoapods/v/SMLinkPreview.svg?style=flat)](http://cocoapods.org/pods/SMLinkPreview)
[![License](https://img.shields.io/cocoapods/l/SMLinkPreview.svg?style=flat)](http://cocoapods.org/pods/SMLinkPreview)
[![Platform](https://img.shields.io/cocoapods/p/SMLinkPreview.svg?style=flat)](http://cocoapods.org/pods/SMLinkPreview)

## Features

### The goals of this library are:
1. To (a) separate the fetching or acquisition of link preview data from (b) the view or UI aspects of the link preview.
2. To enable the app using the link preview data fetching to not have to disable Application Transport Security (ATS).
3. To flexibly allow for different web-based API services that fetch link preview data.

### The LinkPreview view adapts to different available data:

<p float="left">
    <img src="https://github.com/crspybits/SMLinkPreview/blob/master/Docs/Images/LargeImage-OneLineTitle.png" width="200" title="Large Image One Line Title" />
    <img src="https://github.com/crspybits/SMLinkPreview/blob/master/Docs/Images/LargeImage-TwoLineTitle.png" width="200" title="Large Image Two Line Title" /> 
    <img src="https://github.com/crspybits/SMLinkPreview/blob/master/Docs/Images/Icon.png" width="200" title="Icon and URL" />
    <img src="https://github.com/crspybits/SMLinkPreview/blob/master/Docs/Images/OnlyURL.png" width="200" title="Only URL" />
    <img src="https://github.com/crspybits/SMLinkPreview/blob/master/Docs/Images/Icon-TwoLineTitle.png" width="200"title="Icon Two Line Title" />
</p>


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to use

0) Set up plugin's that will do the fetching. You (only) have to have at least one of these:
```
    PreviewManager.session.reset()

    guard let requestKeyName = MicrosoftURLPreview.requestKeyName,
        let microsoftKey = APIKey.getFromPlist(plistKeyName: "MicrosoftURLPreview", requestKeyName: requestKeyName, plistName: "APIKeys") else {
        throw URLPreviewGeneratorError.failedToGetPlistValue
    }
    
    guard let msPreview = MicrosoftURLPreview(apiKey: microsoftKey) else {
        throw URLPreviewGeneratorError.failedToInitializePlugin
    }
    
    guard let adaPreview = AdaSupportPreview(apiKey: nil) else {
        throw URLPreviewGeneratorError.failedToInitializePlugin
    }
    
    guard let mPreview = MicrolinkPreview(apiKey: nil) else {
        throw URLPreviewGeneratorError.failedToInitializePlugin
    }

    PreviewManager.session.add(source: msPreview)
    PreviewManager.session.add(source: adaPreview)
    PreviewManager.session.add(source: mPreview)
```

1) Optionally add some filtering:
```
    // I'm going to require that the linkData have at least some content
    PreviewManager.session.linkDataFilter = { linkData in
        return linkData.description != nil ||
            linkData.icon != nil ||
            linkData.image != nil
    }
```

2) Given that you have a URL that you want to generate a preview for:
```
    PreviewManager.session.getLinkData(url: url) { linkData in
        logger.debug("linkData: \(String(describing: linkData))")
        completion(linkData)
    }
```

3) Use this resulting `linkData` to render a preview:
```
    let preview = LinkPreview.create(with: linkData) { loadedImage in
        // This is optional. Only needed if, for example, you need the UIImage for purposes other than showing it on the screen.
        model.loadedImage = loadedImage
    }
    
    // Add the `preview` to your view hierarchy. 
```

## Installation

### Cocoapods

SMLinkPreview is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:


```ruby
pod 'SMLinkPreview'
```
or

```ruby
pod 'SMLinkPreview', :git => 'https://github.com/crspybits/SMLinkPreview.git'
```

### Swift Package Manager

It is also available through the Swift Package Manager. To install, add the following line to your Package.swift file as a dependency:

```
.package(url: "https://github.com/crspybits/SMLinkPreview.git", from: "0.2.0")
```

## Author

crspybits, chris@SpasticMuffin.biz

## License

SMLinkPreview is available under the MIT license. See the LICENSE file for more info.
