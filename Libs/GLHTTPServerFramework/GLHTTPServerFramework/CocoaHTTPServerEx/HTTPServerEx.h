//
//  HTTPServerEx.h
//  GLHTTPServerFramework
//
//  Created by Abhay on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import <CocoaHTTPServer/CocoaHTTPServer.h>

@protocol GLHTTPRequestDelegate;

/**
 * @class GLRequestConfig
 * @brief This class represents a config for GLHTTPServer
 */
@interface GLRequestConfig : NSObject

@property (nonatomic, assign) id <GLHTTPRequestDelegate> delegate;
@property (nonatomic, retain) NSString *uri;
@property (nonatomic, assign) BOOL isDirectory;

/**
 * @fn     initWithUri: andDelegate:
 * @brief  This method creates an instance of GLRequestConfig and initializes it with uri and delegate
 * @param  uri uri identifier
 * @return delegate a delegate of type GLHTTPRequestDelegate
 * @see    nil
 */
-(id) initWithUri:(NSString *)uri andDelegate:(id <GLHTTPRequestDelegate>) delegate;

@end

/**
 * @class HTTPConfigEx
 * @brief Represnets an extended HTTPConfig that holds array of configs
 */
@interface HTTPConfigEx : HTTPConfig
{
    NSMutableDictionary*    _uris;//uri as key and GLRequestConfig as value
}
-(BOOL) addUriConfig:(GLRequestConfig*)config;
-(void) removeUriConfigForPath:(NSString*)uri;
-(GLRequestConfig*) getUriConfigForPath:(NSString*)uri;
-(NSArray*)allUris;
@end

/**
 * @class HTTPServerEx
 * @brief Represnets an extended HTTPServer that holds an instance of HTTPConfigEx
 */
@interface HTTPServerEx : HTTPServer
{
    HTTPConfigEx*   _config;
}

/**
 * @fn     setConfig
 * @brief  This method sets config for the server
 * @param  config This represents server config info
 * @return void
 * @see    nil
 */
-(void)setConfig:(HTTPConfigEx*)config;

/**
 * @fn     port
 * @brief  This method returns port at which server is hooked up.
 * @param  nil
 * @return UInt16 - port number
 * @see    nil
 */
- (UInt16)port;
@end

