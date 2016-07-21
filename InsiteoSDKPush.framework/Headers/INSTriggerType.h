//
//  INSTriggerType.h
//  InsiteoSDKPush
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#ifndef INSTriggerType_h
#define INSTriggerType_h

/*!
 `INSTriggerType` enum specifies different type of trigger available in Insiteo SDK.
 */
typedef NS_ENUM(NSUInteger, INSTriggerType) {
    /*!
     Unknown trigger type.
     */
    INSTriggerTypeUnknown = -1,
    /*!
     Beacon proximity distance trigger type.
     */
    INSTriggerTypeBeacon = 3,
    /*!
     Geofencing trigger type.
     */
    INSTriggerTypeGeofencing = 4,
    /*!
     Beacon region trigger type.
     */
    INSTriggerTypeBeaconRegion = 5,
};

#endif /* INSTriggerType_h */
