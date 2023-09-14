//
//  Loger.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 14.09.2023.
//

import Foundation
import os.log

class Loger {
    static var shared = Loger()
    
    /// is Logging enable
    var isEnabled: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    static func success(_ message: Any!) {
        Loger.shared.debug(type: "✅", message: message)
    }
    
    static func info(_ message: Any!) {
        Loger.shared.debug(type: "ℹ️", message: message)
    }
    
    static func warning(_ message: Any!) {
        Loger.shared.debug(type: "⚠️", message: message)
    }

    static func error(_ message: Any!) {
        Loger.shared.debug(type: "❌", message: message)
    }
    
    private func debug(type: Any?, message: Any?) {
        guard Loger.shared.isEnabled else { return }
        DispatchQueue.main.async {
            os_log("%@", type: .debug, "\(type ?? "") -> \(message ?? "")")
        }
    }
}
