//
//  AsyncLoader.swift
//  ShowUpp
//
//  Created by Mateus Rodrigues on 07/03/22.
//  Copyright © 2022 Apple Developer Academy IFCE. All rights reserved.
//

import Foundation

public enum AsyncLoaderState<Value> {
    case loading(Task<Value?, Never>)
    case loaded(Value)
}

public enum AsyncLoaderValueCaching {
    
    case enabled(modificationDate: Date? = nil)
    case disabled
    
    public static var enabled: Self { .enabled(modificationDate: nil) }
    
    var isEnabled: Bool {
        if case .enabled = self {
            return true
        } else {
            return false
        }
    }
    
    var modificationDate: Date? {
        if case .enabled(let modificationDate) = self {
            return modificationDate
        } else {
            return nil
        }
    }
    
}

public protocol AsyncLoader: Actor {
    associatedtype Value
    associatedtype ID: Hashable
    var values: [ID: AsyncLoaderState<Value>] { get set }
    func task(for id: ID) -> Task<Value?, Never>
    func cachedValue(for id: ID, modificationDate: Date?) async -> Value?
    func cache(_ value: Value, for id: ID)
}

var values = [1: "", 2: "", 3: "", 4: "", 5: ""]

extension AsyncLoader {
    
    func cancel(for id: ID) {
        if case let .loading(task) = values[id] {
            task.cancel()
        }
    }
    
    public func value(for id: ID, caching: AsyncLoaderValueCaching) async -> Value? {
        
        let task: Task<Value?, Never>
                
        if let state = values[id] {
            switch state {
                case .loaded(let value):
                    print("value from loaded...")
                    return value
                case .loading(let taskInProgress):
                    task = taskInProgress
            }
        } else {
            
            if caching.isEnabled {
                if let cachedValue = await cachedValue(for: id, modificationDate: caching.modificationDate) {
                    print("value from cache...")
                    values[id] = .loaded(cachedValue)
                    return cachedValue
                }
            }
            
            task = self.task(for: id)
            values[id] = .loading(task)
        }
        
        let value = await task.value
        
        print("value from task...")
        
        if let value = value {
            if caching.isEnabled {
                cache(value, for: id)
            }
            values[id] = .loaded(value)
        } else {
            values[id] = nil
        }
        
        return value
        
    }
    
}

import UIKit

actor CharacterImageLoader: AsyncLoader {
    
    static var shared = CharacterImageLoader()
   
    var values: [Int : AsyncLoaderState<UIImage>] = [:]
    
    func task(for id: Int) -> Task<UIImage?, Never> {
        Task {
            
            try? await Task.sleep(for: .seconds(3))
            
            if let (data, _) = try? await URLSession.shared.data(from: URL(string: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg")!) {
                return UIImage(data: data)
            } else {
                return nil
            }
        }
        
    }
    
    func cachedValue(for id: Int, modificationDate: Date?) async -> UIImage? {
                
        guard let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let url = caches.appendingPathComponent("\(id).jpeg")
        
        if let modificationDate {
            
            guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) as [FileAttributeKey: Any] else { return nil }
            
            if let creationDate = attributes[.creationDate] as? Date, creationDate >= modificationDate {
                if let data = try? Data(contentsOf: url) {
                    return UIImage(data: data)
                }
            }
            
        } else {
            if let data = try? Data(contentsOf: url) {
                return UIImage(data: data)
            }
        }
        
        return nil
        
    }
    
    func cache(_ value: UIImage, for id: Int) {
        
        print("caching value...")
        
        guard let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        
        let url = caches.appendingPathComponent("\(id).jpeg")
        
        if let data = value.jpegData(compressionQuality: 1) {
            try? data.write(to: url)
        }
        
    }
    
}
