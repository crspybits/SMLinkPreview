//
//  SourceManager.swift
//  SMLinkPreview
//
//  Created by Christopher G Prince on 4/20/19.
//

import Foundation

public class SourceManager {
    public static let session = SourceManager()
    private var sources = [LinkSource]()
    public var requiredFields:LinkData.Fields = []
    
    // Add LinkSource's in the order you want them tried.
    public func add(source: LinkSource) {
        sources += [source]
    }
    
    // For testing
    func reset() {
        sources = []
    }
    
    public func getLinkData(url: URL, completion: @escaping (LinkData?)->()) {
        getLinkDataAux(sources: sources, url: url, completion: completion)
    }
    
    func getLinkDataAux(sources: [LinkSource], url: URL, completion: @escaping (LinkData?)->()) {
        if sources.count == 0 {
            completion(nil)
        }
        else {
            let source = sources[0]
            let tail = Array(sources[1...sources.count-1])
            source.getLinkData(url: url) {[unowned self] linkData in
                if let linkData = linkData {
                    if let has = self.hasRequiredData(linkData: linkData) {
                        if has {
                            completion(linkData)
                        }
                        else {
                            self.getLinkDataAux(sources: tail, url: url, completion: completion)
                        }
                    }
                    else {
                        completion(nil)
                    }
                }
                else {
                    // With a failure, try next as failover method(s).
                    self.getLinkDataAux(sources: tail, url: url, completion: completion)
                }
            }
        }
    }
    
    func hasRequiredData(linkData: LinkData) -> Bool? {
        for field in LinkData.Fields.all {
            var value: Any?
            
            switch field {
            case .title:
                value = linkData.title
            case .description:
                value = linkData.description
            case .image:
                value = linkData.image
            case .icon:
                value = linkData.icon
            default:
                return nil
            }
            
            if requiredFields.contains(field) && value == nil {
                return false
            }
        }
        
        return true
    }
}
