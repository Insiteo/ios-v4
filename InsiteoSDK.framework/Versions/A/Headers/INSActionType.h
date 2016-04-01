//
//  INSActionType.h
//  Insiteo
//
//  Created by Lionel Rossignol on 11/03/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
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
    /*!
     Passbook action.
     */
    //INSActionTypePassbook,
};

#endif /* INSActionType_h */
