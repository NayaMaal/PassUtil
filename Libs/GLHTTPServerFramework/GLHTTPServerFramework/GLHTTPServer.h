//
//  GLHTTPServer.h
//  GLHTTPServerFramework
//
//  Created by Ashish Ghulghule on 21/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GLHTTPRequestDelegate;

/**
 * @class GLHTTPServer
 * @brief This class represents a custom web server for localhost requests
 */
@interface GLHTTPServer : NSObject

/**
 * @fn     sharedInstance
 * @brief  Provides a singleton instance of GLHTTPServer
 * @param  nil
 * @return Singleton instance of GLHTTPServer
 * @see    nil
 */
+ (GLHTTPServer *)sharedInstance;

/**
 * @fn     registerDelegate
 * @brief  This method registers a delegate for specific uri. Server will start running only if it has
 *         atleast one registered delegate
 * @param  delegate a delegate of type GLHTTPRequestDelegate
 * @param  uri uri identifier
 * @return YES, if delegate registered, returning NO means the delegate has already registered for this URI
 * @see    nil
 */
-(BOOL) registerDelegate: (id <GLHTTPRequestDelegate>) delegate forUri:(NSString *) uri;

/**
 * @fn     registerDelegate
 * @brief  This method registers a delegate for specific directory. Server will start running only if it has
 *         atleast one registered delegate
 * @param  delegate a delegate of type GLHTTPRequestDelegate
 * @param  uri uri identifier
 * @return YES, if delegate registered, returning NO means the delegate has already registered for this URI
 * @see    nil
 */
-(BOOL) registerDelegate: (id <GLHTTPRequestDelegate>) delegate forDir:(NSString *) dir;


/**
 * @fn     unregisterDelegate
 * @brief  This method un-registers a delegate for specific uri/directory. Server will stop running if it has
 *         no registered delegates.
 * @param  delegate a delegate of type GLHTTPRequestDelegate
 * @param  path the uri or directory identifier
 * @return void
 * @see    nil
 */
-(void) unregisterDelegate: (id <GLHTTPRequestDelegate>) delegate forPath:(NSString *) path;

/**
 * @fn     isRunning
 * @brief  Indicates if server is running or not.
 * @param  nil
 * @return BOOL - YES if server is running otherwise returns NO
 * @see    nil
 */
-(BOOL)isRunning;

/**
 * @fn     port
 * @brief  Gives port on which server is hooked up.
 * @param  nil
 * @return UInt16 returns port value.
 * @see    nil
 */
-(UInt16)port;

@end
