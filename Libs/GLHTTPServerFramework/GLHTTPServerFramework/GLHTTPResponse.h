//
//  GLHTTPResponse.h
//  GLHTTPServerFramework
//
//  Created by Ashish Ghulghule on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class GLHTTPResponse
 * @brief Represents a response class. 
 */
@interface GLHTTPResponse : NSObject

@property(nonatomic, assign) NSInteger statusCode;
@property(nonatomic, retain) NSData *data;
@property(nonatomic, retain) NSDictionary *headersInfo;
@property(nonatomic, retain) NSString *errorString;

/**
 * @fn     initWitStatusCode: data:
 * @brief  This method initialises response instance with statuscode and response data
 * @param  statusCode - This is a http response status code.
 * @param  data - This is http response data
 * @return id instance of response class.
 * @see    nil
 */
-(id) initWitStatusCode:(NSInteger) statusCode data:(NSData *) data;

@end
