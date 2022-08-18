//
//  Serial.swift
//  
//
//  Created by Simon Stuart on 18/08/2022.
//

import Foundation
import ThreadSafeSwift
import Observable
import ORSSerial

public class Serial: NSObject, ORSSerialPortDelegate, Serialable {
    internal struct SerialPortKey: Hashable {
        var port: String
        var baud: BaudRate
    }
    
    // Static Members
    
    @ThreadSafeSemaphore private static var instances = [SerialPortKey:Serial]()
    
    public static subscript (port: String, baud: BaudRate) -> Serialable? {
        let key = SerialPortKey(port: port, baud: baud)
        var instance = instances[key]
        if instance == nil {
            instance = Serial(port: port, baud: baud)
            instances[key] = instance
        }
        return instance
    }
    
    // Instance Members
    
        private var _port: String
    public var port: String {
        get {
            return _port
        }
    }
    
    private var _baud: BaudRate
    public var baud: BaudRate {
        get {
            return _baud
        }
    }
    
    public var isReady: Bool {
        get {
            var result: Bool = false
            
            _serialPort.withLock { serialPort in
                if serialPort != nil { result = serialPort!.isOpen }
            }
            return result
        }
    }
    
    @ThreadSafeSemaphore @objc dynamic private var serialPort: ORSSerialPort? {
        willSet {
            _serialPort.withLock { serialPort in
                serialPort?.close()
                serialPort?.delegate = nil
                serialPort = newValue
                serialPort?.delegate = self
                serialPort?.baudRate = self._baud.rawValue
                serialPort?.open()
            }
        }
    }
    
    public func open() {
        serialPort?.open()
    }
    
    public func close() {
        serialPort?.close()
    }
    
    /**
     Invoked as a Callback by the Serial Port whenever it is opened
     - Author: Simon J. Stuart
     - Version: 1.0.0
     */
    public func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        let refTime = mach_absolute_time()
        /// Dispatch the Event with Highest Priority!
        SerialPortOpenedEvent(refTime: refTime, serial: self).queue(priority: .highest)
        withObservers { (observer: SerialObserver) in
            observer.onSerialPortOpened(refTime: refTime, port: self)
        }
    }
    
    /**
     Invoked as a Callback by the Serial Port whenever it is closed
     - Author: Simon J. Stuart
     - Version: 1.0.0
     */
    public func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        let refTime = mach_absolute_time()
        /// Dispatch the Event with Highest Priority!
        SerialPortClosedEvent(refTime: refTime, serial: self).queue(priority: .highest)
        withObservers { (observer: SerialObserver) in
            observer.onSerialPortClosed(refTime: refTime, port: self)
        }
    }
    
    /**
     Invoked as a Callback by the Serial Port whenever it is unplugged
     - Author: Simon J. Stuart
     - Version: 1.0.0
     */
    public func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        let refTime = mach_absolute_time()
        /// Dispatch the Event with Highest Priority!
        SerialPortRemovedEvent(refTime: refTime, serial: self).queue(priority: .highest)
        withObservers { (observer: SerialObserver) in
            observer.onSerialPortRemoved(refTime: refTime, port: self)
        }
    }
    
    /**
     Invoked as a Callback by the Serial Port whenever it receives data from the external peripheral
     - Author: Simon J. Stuart
     - Version: 1.0.0
     */
    public func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        let refTime = mach_absolute_time()
        /// Dispatch the Event with Highest Priority!
        SerialPortDataReceivedEvent(refTime: refTime, serial: self, data: data).queue(priority: .highest)
        withObservers { (observer: SerialObserver) in
            observer.onSerialPortDataReceived(refTime: refTime, port: self, data: data)
        }
    }
    
    /**
     Invoked as a Callback by the Serial Port whenever it encounters an error
     - Author: Simon J. Stuart
     - Version: 1.0.0
     */
    public func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        let refTime = mach_absolute_time()
        /// Dispatch the Event with Highest Priority!
        SerialPortErrorEvent(refTime: refTime, serial: self, error: error).queue(priority: .highest)
        withObservers { (observer: SerialObserver) in
            observer.onSerialPortError(refTime: refTime, port: self, error: error)
        }
    }
    
    // Observer Delegation
    
    internal class SerialObservable: ObservableThreadSafeClass {}
    
    private var observationDelegate: SerialObservable = SerialObservable()
    
    @inline(__always) public func removeObserver<TObservationProtocol>(_ observer: TObservationProtocol) where TObservationProtocol : AnyObject {
        observationDelegate.removeObserver(observer)
    }
    
    @inline(__always) public func addObserver<TObservationProtocol>(_ observer: TObservationProtocol) where TObservationProtocol : AnyObject {
        observationDelegate.addObserver(observer)
    }
    
    @inline(__always) public func withObservers<TObservationProtocol>(_ code: @escaping (TObservationProtocol) -> ()) {
        observationDelegate.withObservers(code)
    }
    
    // Initialisers
    
    private init(port: String, baud: BaudRate = .baud9600) {
        _port = port
        _baud = baud
        serialPort = ORSSerialPort.init(path: port)
        super.init()
        serialPort?.delegate = self
        serialPort?.baudRate = baud.rawValue
        serialPort?.open()
    }
    
    deinit {
        serialPort?.close()
    }
}
