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
    var refTime: UInt64
    var serial: Serialable?
    var data: Data
}
