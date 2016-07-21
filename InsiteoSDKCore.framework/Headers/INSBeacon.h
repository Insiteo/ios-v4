//
//  INSBeacon.h
//  InsiteoSDKCore
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#import <Foundation/Foundation.h>

/*!
 The `INSBeacon` class represents an Insiteo beacon entity.
 */
@interface INSBeacon : NSObject

/*!
 Beacon label.
 */
@property (nonatomic, copy, readonly) NSString *label;

/*!
 Beacon UUID.
 */
@property (nonatomic, copy, readonly) NSString *UUID;

/*!
 Beacon major value.
 */
@property (nonatomic, strong, readonly) NSNumber *major;

/*!
 Beacon minor value.
 */
@property (nonatomic, strong, readonly) NSNumber *minor;

@end
