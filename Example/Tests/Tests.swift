import XCTest
@testable import SMLinkPreview

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func runPreview(previewService: LinkSource, url: URL) {
        let exp = expectation(description: "getLinkData")
        
        previewService.getLinkData(url: url) { linkData in
            XCTAssert(linkData != nil)
            print("\(String(describing: linkData))")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMicrolinkPreview() {
        guard let preview = MicrolinkPreview(apiKey: nil) else {
            XCTFail()
            return
        }
        
        guard let url = URL(string: "https://www.cprince.com") else {
            XCTFail()
            return
        }
        
        runPreview(previewService: preview, url: url)
    }
    
    func testMicrolinkPreviewWithNilTitleAndDescription() {
        guard let preview = MicrolinkPreview(apiKey: nil) else {
            XCTFail()
            return
        }
        
        guard let url = URL(string: "https://www.github.com") else {
            XCTFail()
            return
        }
        
        runPreview(previewService: preview, url: url)
    }
    
    func testAdaSupportPreview() {
        guard let preview = AdaSupportPreview(apiKey: nil) else {
            XCTFail()
            return
        }
        
        guard let url = URL(string: "https://www.github.com") else {
            XCTFail()
            return
        }
        
        runPreview(previewService: preview, url: url)
    }
    
    func testAdaSupportPreview2() {
        guard let preview = AdaSupportPreview(apiKey: nil) else {
            XCTFail()
            return
        }
        
        guard let url = URL(string: "https://www.cprince.com") else {
            XCTFail()
            return
        }
        
        runPreview(previewService: preview, url: url)
    }
    
    func testMicrosoftLinkPreview() {
        guard let requestKeyName = MicrosoftURLPreview.requestKeyName,
            let microsoftKey = APIKey.getFromPlist(plistKeyName: "MicrosoftURLPreview", requestKeyName: requestKeyName, plistName: "APIKeys") else {
            XCTFail()
            return
        }
        
        guard let preview = MicrosoftURLPreview(apiKey: microsoftKey) else {
            XCTFail()
            return
        }
        
        guard let url = URL(string: "https://www.github.com") else {
            XCTFail()
            return
        }
        
        runPreview(previewService: preview, url: url)
    }
    
    func setupSourceManager() -> Bool {
        SourceManager.session.reset()

        guard let requestKeyName = MicrosoftURLPreview.requestKeyName,
            let microsoftKey = APIKey.getFromPlist(plistKeyName: "MicrosoftURLPreview", requestKeyName: requestKeyName, plistName: "APIKeys") else {
            XCTFail()
            return false
        }
        
        guard let msPreview = MicrosoftURLPreview(apiKey: microsoftKey) else {
            XCTFail()
            return false
        }
        
        guard let adaPreview = AdaSupportPreview(apiKey: nil) else {
            XCTFail()
            return false
        }
        
        
        guard let mPreview = MicrolinkPreview(apiKey: nil) else {
            XCTFail()
            return false
        }

        SourceManager.session.add(source: msPreview)
        SourceManager.session.add(source: adaPreview)
        SourceManager.session.add(source: mPreview)
        
        return true
    }
    
    func testSourceManagerWithNoRequiredFields() {
        guard setupSourceManager() else {
            XCTFail()
            return
        }
        
        SourceManager.session.requiredFields = []
        
        guard let url = URL(string: "https://www.github.com") else {
            XCTFail()
            return
        }
        
        let exp = expectation(description: "getLinkData")
        SourceManager.session.getLinkData(url: url) { linkData in
            XCTAssert(linkData != nil)
            print("linkData: \(String(describing: linkData))")
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler:  nil)
    }
    
   func testSourceManager() {
        guard setupSourceManager() else {
            XCTFail()
            return
        }
    
        SourceManager.session.requiredFields = []
    
        guard let url = URL(string: "https://www.cprince.com") else {
            XCTFail()
            return
        }
    
        let exp = expectation(description: "getLinkData")
        SourceManager.session.getLinkData(url: url) { linkData in
            XCTAssert(linkData != nil)
            print("linkData: \(String(describing: linkData))")
            exp.fulfill()
        }
        waitForExpectations(timeout: 30, handler:  nil)
    }
    
    func testSourceManagerWithRequiredFields() {
        guard setupSourceManager() else {
            XCTFail()
            return
        }
        
        SourceManager.session.requiredFields = [.title, .image]
        
        guard let url = URL(string: "https://www.github.com") else {
            XCTFail()
            return
        }
        
        let exp = expectation(description: "getLinkData")
        SourceManager.session.getLinkData(url: url) { linkData in
            XCTAssert(linkData != nil)
            print("linkData: \(String(describing: linkData))")
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler:  nil)
    }
}
