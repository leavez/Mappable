# Mappable

[![Swift](https://img.shields.io/badge/swift-5-orange.svg?style=flat)](#) [![Swift Package Manager](https://rawgit.com/jlyonsmith/artwork/master/SwiftPackageManager/swiftpackagemanager-compatible.svg)](https://swift.org/package-manager/)
[![Build Status](https://travis-ci.org/leavez/Mappable.svg?branch=master)](https://travis-ci.org/leavez/Mappable)
[![Codecov branch](https://img.shields.io/codecov/c/github/leavez/Mappable/master.svg?style=flat)](https://codecov.io/gh/leavez/Mappable)


Mappable is a lightweight, flexible, easy-to-use framework to convert JSON to model, specially optimized for immutable property initialization.

```swift
struct Flight: Mappable {
    let number: String
    let time: Date
    
    init(map: Mapper) throws {

        // with the help of @dynamicMemberLookup feature
        number = try map.id()
        time   = try map.time()

        // or use the old way
        // number = try map.from("id")
        // time   = try map.from("time")
    }
}
// Flight(JSONString: json)
```

A [xcode plugin](https://github.com/leavez/Mappable_xcode_plugin) is also provided to genereate implementation automatically.

## Features

- JSON to object by just specifying mapping relationships
- Optimized for immutable and optional
- Flexible: easy to mix with manual initailization
- Compatible types conversion : e.g. a Int property could be initialized with String value 
- Key path support

## Why Another?

Most JSON to model libraries cannot handle immutable property initialization well. They require to declare properties with `var` and nullable types, which break the sprint of Swift and lead to bad code. Mappable was born for solving this problem.


|              | Pros          | Cons                                                                                                                                                                                                                                         |
|--------------|---------------|---------------|
| Codable      | - Native in Swift<br>- Automatic (no mapping relationships)<br>- support 2-direction conversion | -  Inflexible<br>- Doesn't support inherented class                                                                                                                                                                                               |
| HandyJSON    | - Automatic (no mapping relationships)<br>- 2-direction conversion   | No immutable properties support                                                                                                                                                                               |
| ObjectMapper |  2-direction conversion  | - Immutable properties support is weak* <br>- Multiple partterns led to chaos <br>- Missing support for some combinations of types.|
| SwiftyJSON   |    | Not a JSON object convertor.<br> It's only a convenient tool to deal with JSON data.                                                                                                                                                              |

\* 1) Cannot handle optional conveniently. 2) Doesn't support of compatible types conversion, which fall the whole object for every small mal-format in JSON. 

Mappable is highly inspired by ObjectMapper. You could tread Mappable as an improved version of `ImmutableMappable` in ObjectMapper.


## Usage

### The basics

To support mapping, a type should implement `Mappable` protocol, which have only an initializer method:

```swift
class Country: Mappable {
    let name: String
    let cities: [City]   // struct City: Mappable { ... }
    let atContinent: Continent // enum Continent: Mappable { ... }
    
    required init(map: Mapper) throws {
        name        = try map.from("name")
        cities      = try map.from("city")
        atContinent = try map.from("location.continent")
    }
}
```

You just need write the mapping relationship: a key path for a property. Although these lines are just normal assignment statements, types aren't needed to specified, so you could tread these lines as a special representation of mapping relationships. (You could read the line as "try (to) map (value) from XXX" 😆 )

Then you could initialize a object like this:

```swift
// NOTE: these initializer throw errors, you should do error handling
let c = try Country(JSON: jsonDict)
let d = try? Country(JSONString: jsonString)
```

### Supported types

- Primitive types: `Int`, `Double`, `String`, `Bool`, `URL`, `Date` ...
- Container types: `Array`, `Dictionary`, `Set`
- Optional type
- Enum, Struct, Object
- Any combination of the types above

### Default value

```swift
// just use `??`
cities = try map.from("city") ?? []
```

### Optional handling

`Optional` types won't throw an error even if there's no corresponding date in JSON or the date is in mal-format. A `nil` will be assigned in this situation. 

If you declare a property as an optional, it may mean this data isn't strictly required in JSON. So you wish to get a nil value if there's no data actually. 

```swift
struct User: Mappable {
    let ID: String
    let summary: String?
    
    init(map: Mapper) throws {
        ID      = try map.from("id")
        summary = try map.from("summary")
    }
}
let json = ["id": "a123"]
let user = try! User(JSONObject: json) // It won't crash.
```

### Compatible types conversion

|                             | Convert from                                                 |
| :-------------------------- | ------------------------------------------------------------ |
| Int, Double, Float, CGFloat | String                                                       |
| Bool                        | Int,  "true", "True", "TRUE", "YES", "false", "False", "FALSE", "NO", "0", "1" |
| String                      | Int, NSNumber  |
| URL                         | String  |
| Date                        | Double(secondsSince1970),  String (RFC 3339, e.g. `2016-06-13T16:00:00+00:00`)                                             |

More detail at [here](https://github.com/leavez/Mappable/blob/master/Sources/Mappable/Mappable%2BBasicType.swift).

### Custom conversion

The content in initializer is just plain assignment, so you could do anything with the data. Use `map.getRootValue()` and `map.getValue(keyPath:)` to the get the raw JSON value and do what you want.

For convenient date conversion, there's also a `options` property in `Mapper` to set custom date strategy. (More complex example [here](https://github.com/leavez/Mappable/blob/d492956c0a8626b44cd96987353f9c9b467a3f44/Tests/MappableTests/BasicTypeTest.swift#L287))

### Enum

Enums conforming `RawRepresentable` have a default implementation of `Mappable`. You just need to declare the conforming of `Mappable` to your enum types, then it will work.

For enum with associated values, you could do the manual implementation:

```swift
enum EnumWithValues: Mappable {
    case a(Int)
    case b(String)
    
    init(map: Mapper) throws {
        // It could be initialized with a json date like:
        // {"type": "a", value: 123}
        let value = try map.getValue("type", as: String.self)
        switch value {
        case "a":
            self = .a(try map.from("value"))
        case "b":
            self = .b(try map.from("value"))
        default:
            throw ErrorType.JSONStructureNotMatchDesired(value, "string a/b")
        }
    }
}
```

### Class inheritance

```swift
class ChildModel: BaseModel {
    let b : Int
    required init(map: Mapper) throws {
        b = try map.from("b")
        try super.init(map: map)
    }
}
```

### Nested key path

Use key path "AAA.BBB" to map a multi-level path value in JSON:

```swift
// let json = """ {"AAA": {"BBB": 1}} """
b = try map.from("AAA.BBB")

// use `n` to get a n-th value in array
// let json = """ {"AAA": [11,22,33]} """
b = try map.from("AAA.`2`") // b = 33
```

If a normal key contains `.` naturally, you could use like `map.from("a.file", keyPathIsNested: false)`, to treat the key as a single-level path.

## Installation

- for Swift 5 & 4.2   : v1.3+
- for Swift 4.1 and below : v1.2.2

### Cocoapods

```ruby
pod 'Mappable'
```

### Swift Package Manager

```swift
.Package(url: "https://github.com/leavez/Mappable.git", from: "1.5.0"),
```

### Carthage

```ruby
github "leavez/Mappable"
```

## License

Mappable is available under the MIT license. See the LICENSE file for more info.
