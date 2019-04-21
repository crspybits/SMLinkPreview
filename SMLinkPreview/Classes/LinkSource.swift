//
//  LinkSource.swift
//  SMLinkPreview
//
//  Created by Christopher G Prince on 4/20/19.
//

import Foundation

public struct LinkData {
    public struct Fields: OptionSet {
        public let rawValue: UInt

        public static let title = Fields(rawValue: 1 << 0)
        public static let description = Fields(rawValue: 1 << 1)
        public static let image = Fields(rawValue: 1 << 2)
        public static let icon = Fields(rawValue: 1 << 3)
        
        public static let all:[Fields] = [.title, .description, .image, .icon]

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
    
    public let title: String?
    public let description: String?
    public let image: URL?
    public let icon: URL?
    
    public init(title: String?, description: String?, image: URL?, icon: URL?) {
        self.image = image
        self.icon = icon
        self.description = description
        self.title = title
    }
}

public struct APIKey {
    public let requestKey: String
    public let value: String
    
    public init(requestKey: String, value: String) {
        self.requestKey = requestKey
        self.value = value
    }
    
    // Don't give the .plist extension with the plistName
    public static func getFromPlist(plistKeyName: String, requestKeyName: String, plistName: String, bundle: Bundle = Bundle.main) -> APIKey? {
        
        if let path = bundle.path(forResource: plistName, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let value = dict[plistKeyName] as? String {
            return APIKey(requestKey: requestKeyName, value: value)
        }
        
        return nil
    }
}

public protocol LinkSource {
    static var requestKeyName: String? {get}
    init?(apiKey: APIKey?)
    func getLinkData(url: URL, completion: @escaping (LinkData?)->())
}

