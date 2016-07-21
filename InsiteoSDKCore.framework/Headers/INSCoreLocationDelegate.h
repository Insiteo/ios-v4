//
//  INSCoreLocationDelegate.h
//  InsiteoSDKCore
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@class INSBeaconRegion, INSBeacon, INSGeofenceArea;

/*!
 The `INSCoreLocationDelegate` protocol defines optional methods for location detection events delegation.
 */
@protocol INSCoreLocationDelegate <NSObject>

@optional

///-------------------------------
/// @name Beacon
///-------------------------------

/*!
 Sent when the user enters in a beacon region.
 
 @param beaconRegion The detected region.
 */
- (void)onBeaconRegionEnter:(INSBeaconRegion *)beaconRegion;

/*!
 Sent when the user leaves a beacon region.
 
 @param beaconRegion The detected region.
 */
- (void)onBeaconRegionExit:(INSBeaconRegion *)beaconRegion;

/*!
 Sent when the state of a region has changed.
 
 @param beaconRegion The detected region.
 @param state        The new state.
 */
- (void)onBeaconRegion:(INSBeaconRegion *)beaconRegion newStateDetected:(CLRegionState)state;

/*!
 Sent when beacons are ranged in a specific region.
 
 @param beacons      The beacons found.
 @param beaconRegion The ranging region.
 */
- (void)onBeaconsRanged:(NSArray<INSBeacon *>*)beacons inBeaconRegion:(INSBeaconRegion *)beaconRegion;

///-------------------------------
/// @name Geofencing
///-------------------------------

/*!
 Sent when the user enters in a circular geofence area.
 
 @param geofenceArea The detected geofence area.
 */
- (void)onGeofenceAreaEnter:(INSGeofenceArea *)geofenceArea;

/*!
 Sent when the user leaves a circular geofence area.
 
 @param geofenceArea The detected geofence area.
 */
- (void)onGeofenceAreaExit:(INSGeofenceArea *)geofenceArea;

/*!
 Sent when the states of a circular geofence area has changed.
 
 @param geofenceArea The detected geofence area.
 @param state        The new state.
 */
- (void)onGeofenceArea:(INSGeofenceArea *)geofenceArea newStateDetected:(CLRegionState)state;

@end
