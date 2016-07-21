//
//  INSGeofenceArea.h
//  InsiteoSDKCore
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

/*!
 The `INSGeofenceArea` class represents an Insiteo geofencing circular region entity.
 */
@interface INSGeofenceArea : NSObject

/*!
 Geofence area label.
 */
@property (nonatomic, copy, readonly) NSString *label;

/*!
 Geofence area coordinates (latitude, longitude).
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinates;

/*!
 Geofence area radius in meters.
 */
@property (nonatomic, assign, readonly) double radius;

@end
