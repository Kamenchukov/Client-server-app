//
//  AsyncOperation.swift
//  VkApp
//
//  Created by Константин Каменчуков on 08.11.2021.
//

import Foundation

class AsyncOpeation: Operation {
     enum State: String {
         case ready
         case executing
         case finished

         var keyPath: String {
             return "is\(rawValue.capitalized)"
         }
     }

     var state = State.ready {
             willSet {
                 willChangeValue(forKey: state.keyPath)
                 willChangeValue(forKey: newValue.keyPath)
             }
             didSet {
                 didChangeValue(forKey: state.keyPath)
                 didChangeValue(forKey: oldValue.keyPath)
             }
         }

     override var isAsynchronous: Bool {
         return true
     }

     override var isReady: Bool {
         return super.isReady && state == .ready
     }

     override var isExecuting: Bool {
         return state == .executing
     }

     override var isFinished: Bool {
         return state == .finished
     }

     override func start() {
         if isCancelled {
             state = .finished
         } else {
             main()
             state = .executing
         }
     }

     override func cancel() {
         super.cancel()
         state = .finished
     }

 }
