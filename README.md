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
```

###Instance Of Declared Type

```swift
// Registers an instance of MyCoolType as Type AnyObject
let instance: AnyObject = MyCoolType()
provider.registerInstance(instance)
```

###Transient Factory of Specified Type

```swift
// Registers a factory that will generate a new MyCoolType on each Get
provider.registerType({ (provider) -> MyCoolType in
    return MyCoolType()
})
```

###Singleton Factory of Specified Type

```swift
// Registers a factory that will generate a singleton of MyCoolType on each Get
provider.registerType({ (provider) -> MyCoolType in
return MyCoolType()
}).singleton()
```

##Service Get

###Instance of Specified Type

```swift
// Will return the last instance registered for AnyObject, cast to the Specified Type
let instance = provider.getInstanceOf(AnyObject.self)
```

###Instance of Declared Type

```swift
// Will return the last instance registered for MyCoolType, cast to the Declared Type
let instance: MyCoolType = getInstance() 
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

1. Register Named Versions
2. Register Many Of For a Type
3. Cocoapods