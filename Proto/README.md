#  Proto models

.proto models were restored from compiled Java protobuf classes on Android app. Protobuf packages' names mostly are preserved

All proto models have proto3 syntax

Protobuf models are visible only on framework context

## Proto compile

```
protoc --swift_out=../Sources/SwiftySpot/Proto/Generated --proto_path=. *.proto
```
