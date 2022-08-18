# SerialSwift

<p>
    <img src="https://img.shields.io/badge/Swift-5.1%2B-yellowgreen.svg?style=flat" />
    <img src="https://img.shields.io/badge/macOS-10.15+-179AC8.svg" />
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" />
    <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" />
    </a>
</p>

`SerialSwift` makes communicating with your Serial Peripherals on MacOS trivial.

Better still, `SerialSwift` is designed to be fundamnetally *Observable* and *Event-Driven*, making it easier than ever before to consume information coming into your application from your external Serial peripheral(s).

`SerialSwift` is built on top of a number of packages:
- [`ThreadSafeSwift` from ourselves at Flowduino](https://github.com/Flowduino/ThreadSafeSwift) is used to ensure Thread-Safety throughout the library
- [`Observable` from ourselves at Flowduino](https://github.com/Flowduino/Observable) is used to provide protocol-conformance Observer Pattern support throughout the library
- [`EventDrivenSwift` from ourselves at Flowduino](https://github.com/Flowduino/EventDrivenSwift) is used to emit relevant and extremely high-performance *Events* for every Serial Event your Peripherals generate.
- [`ORSSerialPort` from Armadsen](https://github.com/armadsen/ORSSerialPort) is used to actually interface with your Serial Peripherals.

In this way, `SerialSwift` can be integrated into your code in any way you prefer, making it extremely versatile.

## Installation
### Xcode Projects
Select `File` -> `Swift Packages` -> `Add Package Dependency` and enter `https://github.com/Flowduino/SerialSwift.git`

### Swift Package Manager Projects
You can use `SerialSwift` as a Package Dependency in your own Packages' `Package.swift` file:
```swift
let package = Package(
    //...
    dependencies: [
        .package(
            url: "https://github.com/Flowduino/SerialSwift.git",
            .upToNextMajor(from: "1.0.0")
        ),
    ],
    //...
)
```

From there, refer to `SerialSwift` as a "target dependency" in any of _your_ package's targets that need it.

```swift
targets: [
    .target(
        name: "YourLibrary",
        dependencies: [
          "SerialSwift",
        ],
        //...
    ),
    //...
]
```
You can then do `import SerialSwift` in any code that requires it.

## Usage

Here are some quick and easy usage examples for the features provided by `SerialSwift`:

### Connecting to your Serial Peripheral
You can create an instance of `SerialSwift` per Peripheral as easily as this:
```swift
var mySerialDevice = Serial["/dev/cu.myserialdevice", .baud9600]
```
You would, of course, substitute both parameters in the above example with (firstly) the path to your Serial device, followed by (secondly) the Baud Rate your Serial Device uses.

It is recommended that you retain a reference to your `Serialable` object somewhere globally in your application (such as on the `Environment` of your application, or as a *Singleton*). This is because, from the moment you connect to your Serial peripheral, it will begin emitting *Events* that you can consume anywhere in your application... as demonstrated below.

### Events your Serial device will emit throughout your Application
Now that you have connected to your Serial device, the following *Events* will be emitted universally throughout your application, and can be consumed from *anywhere* in your code.

#### `SerialPortClosedEvent`
If you need to perform a specific operation any time your connection to your Serial device closes, you can do so simply from *anywhere* in your code:
```swift
SerialPortClosedEvent.addListener(self) { (event: SerialPortClosedEvent, priority) in
    /**
        Your code goes in here!
        Properties available to you:
        `event.refTime` = the precise "Mach Time" at which the Serial Port closed
        `event.serial` = A reference to the Serial device which triggered the Event.
        
        You can use `if ObjectIdentifier(event.serial) != ObjectIdentifier(mySerialDevice) { return }` to ensure you're only acting on Events emitted by a specific Serial device 
    */
}
```

#### `SerialPortDataReceivedEvent`
If you need to perform a specific operation any time your Serial device sends Data to your computer, you can do so simply from *anywhere* in your code:
```swift
SerialPortDataReceivedEvent.addListener(self) { (event: SerialPortDataReceivedEvent, priority) in
    /**
        Your code goes in here!
        Properties available to you:
        `event.refTime` = the precise "Mach Time" at which the Serial Port closed
        `event.serial` = A reference to the Serial device which triggered the Event.
        `event.data` = The actual `Data` your Serial device sent to your computer.
        
        You can use `if ObjectIdentifier(event.serial) != ObjectIdentifier(mySerialDevice) { return }` to ensure you're only acting on Events emitted by a specific Serial device 
    */
}
```

#### `SerialPortErrorEvent`
If you need to perform a specific operation any time your Serial device encounters an Error, you can do so simply from *anywhere* in your code:
```swift
SerialPortErrorEvent.addListener(self) { (event: SerialPortErrorEvent, priority) in
    /**
        Your code goes in here!
        Properties available to you:
        `event.refTime` = the precise "Mach Time" at which the Serial Port closed
        `event.serial` = A reference to the Serial device which triggered the Event.
        `event.error` = The actual `Error` your Serial device encountered.
        
        You can use `if ObjectIdentifier(event.serial) != ObjectIdentifier(mySerialDevice) { return }` to ensure you're only acting on Events emitted by a specific Serial device 
    */
}
```

#### `SerialPortOpenedEvent`
If you need to perform a specific operation any time your Serial device establishes a connection with your Computer, you can do so simply from *anywhere* in your code:
```swift
SerialPortOpenedEvent.addListener(self) { (event: SerialPortOpenedEvent, priority) in
    /**
        Your code goes in here!
        Properties available to you:
        `event.refTime` = the precise "Mach Time" at which the Serial Port closed
        `event.serial` = A reference to the Serial device which triggered the Event.
        
        You can use `if ObjectIdentifier(event.serial) != ObjectIdentifier(mySerialDevice) { return }` to ensure you're only acting on Events emitted by a specific Serial device 
    */
}
```

#### `SerialPortRemovedEvent`
If you need to perform a specific operation any time your Serial device disconnects from your Computer, you can do so simply from *anywhere* in your code:
```swift
SerialPortRemovedEvent.addListener(self) { (event: SerialPortRemovedEvent, priority) in
    /**
        Your code goes in here!
        Properties available to you:
        `event.refTime` = the precise "Mach Time" at which the Serial Port closed
        `event.serial` = A reference to the Serial device which triggered the Event.
        
        You can use `if ObjectIdentifier(event.serial) != ObjectIdentifier(mySerialDevice) { return }` to ensure you're only acting on Events emitted by a specific Serial device 
    */
}
```

## License

`SerialSwift` is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.

## Join us on Discord

If you require additional support, or would like to discuss `SerialSwift`, Swift, or any other topics related to Flowduino, you can [join us on Discord](https://discord.com/invite/GdZZKFTQ2A).
