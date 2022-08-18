import XCTest
@testable import SerialSwift

final class SerialTests: XCTestCase {
    class TestObserver: SerialObserver {
        var onPortOpened: ((_ refTime: UInt64, _ port: Serialable) -> ())? = nil
        var onPortClosed: ((_ refTime: UInt64, _ port: Serialable) -> ())? = nil
        var onPortRemoved: ((_ refTime: UInt64, _ port: Serialable) -> ())? = nil
        var onPortDataReceived: ((_ refTime: UInt64, _ port: Serialable, _ data: Data) -> ())? = nil
        var onPortError: ((_ refTime: UInt64, _ port: Serialable, _ error: Error) -> ())? = nil
        
        func onSerialPortOpened(refTime: UInt64, port: Serialable) {
            print("onSerialPortOpened at refTime \(refTime) port: \(port.port), baud: \(port.baud)")
            onPortOpened?(refTime, port)
        }
        
        func onSerialPortClosed(refTime: UInt64, port: Serialable) {
            print("onSerialPortClosed at refTime \(refTime) port: \(port.port), baud: \(port.baud)")
            onPortClosed?(refTime, port)
        }
        
        func onSerialPortRemoved(refTime: UInt64, port: Serialable) {
            print("onSerialPortRemoved at refTime \(refTime) port: \(port.port), baud: \(port.baud)")
            onPortRemoved?(refTime, port)
        }
        
        func onSerialPortDataReceived(refTime: UInt64, port: Serialable, data: Data) {
            print("onSerialPortDataReceived at refTime \(refTime) port: \(port.port), baud: \(port.baud), data: \(data)")
            onPortDataReceived?(refTime, port, data)
        }
        
        func onSerialPortError(refTime: UInt64, port: Serialable, error: Error) {
            print("onSerialPortError at refTime \(refTime) port: \(port.port), baud: \(port.baud), error: \(error)")
            onPortError?(refTime, port, error)
        }
    }
    
    func testSerial() throws {
        let port = Serial["/dev/cu.usbmodem123451", .baud9600]
        if port == nil {
            XCTFail("Port could not be opened!")
            return
        }
        let portActual = port!
        let observer = TestObserver()
        var receivedSomething: Bool = false
        let exp = expectation(description: "Port Closed")
        observer.onPortRemoved = { (refTime, port) in
            receivedSomething = true
            exp.fulfill()
        }
        observer.onPortDataReceived = { (refTime, port, data) in
            receivedSomething = true
            exp.fulfill()
        }
        
        portActual.addObserver(observer)
        let _ = XCTWaiter.wait(for: [exp], timeout: 5.0) // We don't care about the result, because we'll assert regardless of timeout or early fullfillment
        XCTAssertEqual(receivedSomething, true)
    }
}
