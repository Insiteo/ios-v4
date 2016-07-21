# Insiteo iOS SDK Change Log v4.x
All notable changes to Insiteo iOS SDK will be documented in this file.

## 4.1.0 - 2016-07-21
The Insiteo SDK v4.1.0 brings many changes to previous version beacause it has been redesigned to work as a modular framework.

### Added
- `InsiteoSDKCore.framework` : framework which includes common SDK classes, API usage, location services and analytics tracking.
- Added geofencing service detection.
- Added `+resetSDK` method to stop and clean up the SDK into `Insiteo` class.
- Added `INSBeaconRegion`, `INSBeacon`, `INSGeofenceArea` classes to quickly access location entity information when detected.
- Added `INSCoreLocationDelegate` to subscribe to proximity location events (iBeacon and geofencing) through `+registerLocationEventsDelegate` static method in `Insiteo` class.
- Added `INSSDKModule` protocol that defines every required methods for SDK modules.
- `InsiteoSDKPush.framework` : framework to use location proximity interaction service (Push).
- Added geofencing triggers: Push module can now trigger actions based on geofencing areas boundary crossing.

### Changed
- `InsiteoSDK.framework` has been splitted into two new frameworks `InsiteoSDKCore.framework` and `InsiteoSDKPush.framework`.
- `+initializeWithAPIKey:error:` from `Insiteo` class has been renamed. You can now specify which module will be instantiate by the SDK using `+initializeWithAPIKey:modules:error:`.
- `+isModuleAvailable` method has been renamed to `+isAvailable` in `INSAnalytics` and `INSPush` classes.
- The `INSPushAction` notification property is now in `readwrite` mode to let you changing its default `title`, `body`, `userInfo` or even set to `nil` before to override default presentation.
- The `INSTriggerSource` enum has been renamed to `INSTriggerType`.
- The `-shouldExecuteAction:triggeredBy:` delegate method in `INSPushDelegate` has been renamed to `-shouldExecuteAction:triggeredBy:triggerType:` to easily retrieve the source (object) which has triggered the action.

### Removed
- `INSLogger` has been removed so if you want to display SDK logs in console, you have to use `+getSDKLogLevel` and `+setSDKLogLevel` method in `Insiteo` class. All `INSLogLevel` have moved into `INSConstants.h` file.
- `InsiteoSDKVersion` has been removed from `INSConstants.h` file and renamed to `INSITEO_SDK_VERSION_STRING` into `InsiteoSDKCore.h` umbrella header file.
