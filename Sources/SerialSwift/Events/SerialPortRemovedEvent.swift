//
//  SerialPortRemovedEvent.swift
//  SebaSwift
//
//  Created by Simon Stuart on 18th August 2022
//  Copyright (c) 2022, Flowduino (Simon J. Stuart), All Rights Reserved
//

import Foundation
import EventDrivenSwift

/**
 Dispatched any time a Serial Interface is removed from the system
 */
public struct SerialPortRemovedEvent: Eventable {
    public var refTime: UInt64
    public var serial: Serialable?
}
