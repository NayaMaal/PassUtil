//
//  GLHTTPRequest.m
//  GLHTTPServerFramework
//
//  Created by Ashish Ghulghule on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import "GLHTTPRequest.h"

@implementation GLHTTPRequest
@synthesize uri = _uri;
@synthesize method = _method;
@synthesize headers;
@synthesize data;

-(id) initWithUri:(NSString *) uri andMethod:(NSString *) method
{
    if (self = [super init]) {
        _uri = uri;
        _method = method;
    }
    return self;
}
@end
