//
//  INSActionType.h
//  InsiteoSDKPush
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#ifndef INSActionType_h
#define INSActionType_h

/*!
 `INSActionType` enum specifies the different types of action.
 */
typedef NS_ENUM(NSUInteger, INSActionType) {
    /*!
     Notification action.
     */
    INSActionTypeNotification = 1,
    /*!
     Custom action.
     */
    INSActionTypeCustom,
    /*!
     Web View action.
     */
    INSActionTypeWebView,
};

#endif /* INSActionType_h */
