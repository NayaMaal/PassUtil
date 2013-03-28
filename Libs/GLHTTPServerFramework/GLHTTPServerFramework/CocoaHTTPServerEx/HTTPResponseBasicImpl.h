//
//  HTTPResponseBasicImpl.h
//  GLHTTPServerFramework
//
//  Created by NAG1-MAC-26584 on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaHTTPServer/CocoaHTTPServer.h>
#import "GLHTTPResponse.h"

/**
 * @class HTTPResponseBasicImpl
 * @brief This class provides basic implementation for handling HTTP response.
 */
@interface HTTPResponseBasicImpl : NSObject <HTTPResponse>
{
    GLHTTPResponse*     _response;
    NSUInteger          _offset;
}

/**
 * @fn     initWithResponse
 * @brief  This method creates and intilizes an instance of HTTPResponseBasicImpl with GLHTTPResponse instance
 * @param  response an instance of GLHTTPResponse
 * @return id an instance of HTTPResponseBasicImpl
 * @see    nil
 */
-(id) initWithResponse:(GLHTTPResponse*)response;

/**
 * @fn     setResponse
 * @brief  This method sets HTTPResponseBasicImpl instance with response data from an instance of GLHTTPResponse
 * @param  response an instance of GLHTTPResponse
 * @return id an instance of HTTPResponseBasicImpl
 * @see    nil
 */
- (void)setResponse:(GLHTTPResponse*)response;
@end