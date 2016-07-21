//
//  INSBeaconRegion.h
//  InsiteoSDKCore
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#import <Foundation/Foundation.h>

/*!
 The `INSBeaconRegion` class represents an Insiteo beacon region entity.
 */
@interface INSBeaconRegion : NSObject

/*!
 Beacon region label.
 */
@property (nonatomic, copy, readonly) NSString *label;

/*!
 Beacon region UUID value.
 */
@property (nonatomic, copy, readonly) NSString *UUID;

/*!
 Beacon region major value (could be nil).
 */
@property (nonatomic, strong, readonly) NSNumber *major;

/*!
 Beacon region minor value (could be nil).
 */
@property (nonatomic, strong, readonly) NSNumber *minor;

@end
