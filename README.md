# ACServiceProvider
Simple Swift Service Provider

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Twitter](https://img.shields.io/badge/twitter-@Agies1-blue.svg?style=flat)](http://twitter.com/Agies1)
[![Build Status](https://travis-ci.org/Agies/ACServiceProvider.svg?branch=master)](https://travis-ci.org/Agies/ACServiceProvider)

#Examples

##Service Registration

###Instance Of Class Type

```swift
// Registers an instance of the Type MyCoolType
provider.registerInstance(MyCoolType())
```

###Instance Of Specified Type

```swift
// Registers an instance of MyCoolType as Type AnyObject
provider.registerInstanceOf(AnyObject.self, obj: MyCoolType())

provider.registerInstanceOf(AnyObject.self, obj: MyCoolType(), name: "MyName")
```

###Instance Of Declared Type

```swift
// Registers an instance of MyCoolType as Type AnyObject
let instance: AnyObject = MyCoolType()
provider.registerInstance(instance)

provider.registerInstance(instance, name: "NamedInstance")
```

###Transient Factory of Specified Type

```swift
// Registers a factory that will generate a new MyCoolType on each Get
provider.registerType({ (provider) -> MyCoolType in
    return MyCoolType()
})

provider.registerType("MyName", factory: { (provider) -> MyCoolType in
    return MyCoolType()
})
```

###Singleton Factory of Specified Type

```swift
// Registers a factory that will generate a singleton of MyCoolType on each Get
provider.registerType({ (provider) -> MyCoolType in
    return MyCoolType()
}).singleton()


provider.registerType("MyName", factory: { (provider) -> NSObject in
    return NSObject()
}).singleton()

```

##Service Get

###Instance of Specified Type

```swift
// Will return the last instance registered for AnyObject, cast to the Specified Type
let instance = provider.getInstanceOf(AnyObject.self)

let instance = provider.getInstanceOf(AnyObject.self, name: "MyName")
```

###Instance of Declared Type

```swift
// Will return the last instance registered for MyCoolType, cast to the Declared Type
let instance: MyCoolType = getInstance() 

let instance: MyCoolType = getInstance(name: "MyName") 
```

###Get All Instances

```swift
// By registering many objects for the same Type, you are able to pull each out by name
// Or, you are able to GetAll objects registered to that Type
provider.registerInstance("1", name: "0")
provider.registerInstanceOf(String.self, obj: "2", name: "1")
provider.registerType("2", factory: { (p) -> String in
    "3"
})

let getAll: [String] = provider.getAll()

subject.getInstanceOf(String.self, name: "0") == "1"

subject.getInstanceOf(String.self, name: "1") == "2"

subject.getInstanceOf(String.self, name: "2") == "3"

getAll[0] == "1"
getAll[1] == "2"
getAll[2] == "3"
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ACServiceProvider into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Agies/ACServiceProvider" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `ACServiceProvider.framework` into your Xcode project.

##Next

1. Cocoapods