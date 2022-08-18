//
//  SerialPortDataReceivedEvent.swift
//  SebaSwift
//
//  Created by Simon Stuart on 18th August 2022
//  Copyright (c) 2022, Flowduino (Simon J. Stuart), All Rights Reserved
//

import Foundation
import EventDrivenSwift

/**
 Dispatched any time a Serial Interface receives data from the peripheral device
 */
public struct SerialPortDataReceivedEvent: Eventable {
    public var refTime: UInt64
    public var serial: Serialable?
    public var data: Data
}
