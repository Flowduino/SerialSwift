//
//  SerialObserver.swift
//  
//
//  Created by Simon Stuart on 18/08/2022.
//

import Foundation

public protocol SerialObserver: AnyObject {
    func onSerialPortOpened(refTime: UInt64, port: Serialable)
    func onSerialPortClosed(refTime: UInt64, port: Serialable)
    func onSerialPortRemoved(refTime: UInt64, port: Serialable)
    func onSerialPortDataReceived(refTime: UInt64, port: Serialable, data: Data)
    func onSerialPortError(refTime: UInt64, port: Serialable, error: Error)
}
