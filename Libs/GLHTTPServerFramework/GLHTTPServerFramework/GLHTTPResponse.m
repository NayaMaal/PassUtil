//
//  GLHTTPResponse.m
//  GLHTTPServerFramework
//
//  Created by Ashish Ghulghule on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import "GLHTTPResponse.h"

@implementation GLHTTPResponse

@synthesize statusCode = _statusCode;
@synthesize data = _data;
@synthesize errorString = _errorString;
@synthesize headersInfo = _headersInfo;

-(id) initWitStatusCode:(NSInteger) statusCode data:(NSData *) data
{
    if (self = [super init])
    {
        _statusCode = statusCode;
        _data = data;
    }
    return self;
}
    

@end
