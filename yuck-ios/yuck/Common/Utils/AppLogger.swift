//
//  AppLogger.swift
//  workout-stats
//
//  Created by Dominika Gajdová on 02.04.2023.
//

import XCGLogger

private var _logger: XCGLogger?

public var logger: XCGLogger {
    if let logger = _logger {
        return logger
    }

    let log = XCGLogger(identifier: "BoneSystemsLogger", includeDefaultDestinations: false)

    #if DEBUG
        let consoleDestination = ConsoleDestination(owner: log, identifier: "ConsoleDestination")
        consoleDestination.showFunctionName = false
        consoleDestination.outputLevel = .verbose
        log.add(destination: consoleDestination)
    #endif

    log.logAppDetails()

    _logger = log

    return log
}
