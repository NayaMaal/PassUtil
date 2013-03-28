//
//  HTTPServerEx.m
//  GLHTTPServerFramework
//
//  Created by NAG1-MAC-26584 on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import "HTTPServerEx.h"


@implementation GLRequestConfig

@synthesize uri = _uri;
@synthesize delegate = _delegate;

-(id) initWithUri:(NSString *)uri andDelegate:(id <GLHTTPRequestDelegate>) delegate;
{
    if (self = [super init]) {
        _delegate = delegate;
        _uri = uri;
    }
    return self;
}
@end


@implementation HTTPConfigEx

-(BOOL) addUriConfig:(GLRequestConfig*)config
{
    if(!_uris)
        _uris = [NSMutableDictionary dictionary];
    if([_uris objectForKey:config.uri])
        return NO;
    [_uris setObject:config forKey:config.uri];
    return YES;
}
-(void) removeUriConfigForPath:(NSString*)uri
{
    [_uris removeObjectForKey:uri];
}

-(GLRequestConfig*) getUriConfigForPath:(NSString*)uri
{
    if(_uris && uri)
    {
        return [_uris objectForKey:uri];
    }
    return nil;
}

-(NSArray*)allUris
{
    return [_uris allValues];
}

@end


@implementation HTTPServerEx


-(void)setConfig:(HTTPConfigEx*)config
{
    _config = config;
}

- (HTTPConfig *)config
{
    return _config;
}

- (UInt16)port
{
    return [asyncSocket localPort];
}

@end
