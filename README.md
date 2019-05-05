# SMLinkPreview

## Features

### The goal of this library is:
1. To (a) separate the fetching or acquisition of link preview data from (b) the view or UI aspects of the link preview.
2. To enable the app using the link preview data fetching to not have to disable Application Transport Security (ATS).
3. To flexibly allow for different web-based API services that fetch link preview data.

### The LinkPreview view adapts to different available data:

![LargeImage OneLineTitle](Docs/Images/LargeImage-OneLineTitle.png "LargeImage OneLineTitle") 
![LargeImage TwoLineTitle](LargeImage-TwoLineTitle.png "LargeImage TwoLineTitle")
![Only URL](OnlyURL.png "Only URL")
![Icon and URL](Icon.png "Icon and URL")
![Icon TwoLineTitle](Icon-TwoLineTitle.png "Icon TwoLineTitle")

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SMLinkPreview is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SMLinkPreview', :git => 'https://github.com/crspybits/SMLinkPreview.git'
```

## Author

crspybits, chris@SpasticMuffin.biz

## License

SMLinkPreview is available under the MIT license. See the LICENSE file for more info.
