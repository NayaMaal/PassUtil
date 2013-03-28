//
//  GLHTTPConnection.m
//  GLHTTPServerFramework
//
//  Created by Ashish Ghulghule on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//
#import <CocoaHTTPServer/CocoaHTTPServer.h>
#import "GLHTTPConnection.h"
#import "GLHTTPResponse.h"
#import "GLHTTPRequest.h"
#import "HTTPResponseBasicImpl.h"
#import "HTTPServerEx.h"
#import "GLHTTPRequestDelegate.h"

@implementation GLHTTPConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    NSObject<HTTPResponse>* httpresponse = nil;
    NSString* uriPath = path;
    NSRange rang = [path rangeOfString:@"?"];
    if(rang.location != NSNotFound)
    {
        uriPath = [path substringToIndex:rang.location];
    }
    if([config isKindOfClass:[HTTPConfigEx class]])
    {
        HTTPConfigEx* configEx = (HTTPConfigEx*)config;
        NSArray* allConfigs = [configEx allUris];
        for(GLRequestConfig* uriConfig in allConfigs)
        {
            BOOL handller = NO;
            if(uriConfig.isDirectory)
            {
                if([path hasPrefix:uriConfig.uri])
                {
                    if(path.length == uriConfig.uri.length || [path characterAtIndex:uriConfig.uri.length=='/'])
                    {
                        handller = YES;
                    }
                }
            }else if(strcmp([uriConfig.uri UTF8String],[uriPath UTF8String])==0)
            {
                handller = YES;
            }
            if(handller == YES)
            {
                GLHTTPRequest* rqst     = [[GLHTTPRequest alloc]initWithUri:path andMethod:method];
                rqst.headers            = [request allHeaderFields];
                rqst.data               = [request body];
                GLHTTPResponse* resp = nil;
                
                if (uriConfig.delegate && [uriConfig.delegate conformsToProtocol:@protocol(GLHTTPRequestDelegate)])
                {
                    if ([uriConfig.delegate respondsToSelector:@selector(handleRequest:)])
                    {
                        resp = [uriConfig.delegate handleRequest:rqst];
                    }
                }
                
                if(resp)
                {
                    httpresponse = [[HTTPResponseBasicImpl alloc]initWithResponse:resp];
                }
            }
        }
    }
    return httpresponse;
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
    return YES;//let the delegate decides, they supports this method or not.
}
@end
