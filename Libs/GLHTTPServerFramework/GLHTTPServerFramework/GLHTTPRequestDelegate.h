//
//  GLHTTPRequestDelegate.h
//  GLHTTPServerFramework
//
//  Created by Ashish Ghulghule on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLHTTPResponse.h"
#import "GLHTTPRequest.h"

/**
 * @protocol GLHTTPRequestDelegate
 * @brief    This protocol informs delegates of handling requests.
 * @fn       handleRequest
 */
@protocol GLHTTPRequestDelegate <NSObject>

@required
/**
 * @fn     handleRequest
 * @brief  This method asks delegate to handle the request.
 * @param  request - This is a GLHTTPRequest.
 * @return GLHTTPResponse - an instance of GLHTTPResponse.
 * @see    nil
 */
-(GLHTTPResponse *) handleRequest:(GLHTTPRequest *) request;

@end
