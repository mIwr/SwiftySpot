#  Proto models

.proto models were restored from compiled Java protobuf classes on Android app. Protobuf packages' names mostly are preserved

All proto models have proto3 syntax

Protobuf models at './' are visible only on framework context.
Protobuf models at 'public' have public access level and visible outside of framework context

## Proto compile

```
protoc --proto_path=. *.proto --swift_out=../Sources/SwiftySpot/Proto/Generated
cd public
protoc --proto_path=. *.proto --swift_opt=Visibility=public --swift_out=../../Sources/SwiftySpot/Proto/Generated
```
