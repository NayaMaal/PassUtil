//
//  GLHTTPRequest.h
//  GLHTTPServerFramework
//
//  Created by Ashish Ghulghule on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class GLHTTPRequest
 * @brief This class represents a GLHTTRequest. Delegates of GLHTTPServer use this request
 *        to use customize http request.
 */
@interface GLHTTPRequest : NSObject

@property(nonatomic, retain) NSString       *uri;
@property(nonatomic, retain) NSString       *method;
@property(nonatomic, retain) NSDictionary*  headers;
@property(nonatomic, retain) NSData*        data;

/**
 * @fn     initWithUri: andMethod:
 * @brief  This method initialises an instance of GLHTTPRequest with uri and method.
 * @param  uri uri identifier
 * @param  method http method e.g POST, GET etc
 * @return id an instance of GLHTTPRequest
 * @see    nil
 */
-(id) initWithUri:(NSString *) uri andMethod:(NSString *) method;
@end
