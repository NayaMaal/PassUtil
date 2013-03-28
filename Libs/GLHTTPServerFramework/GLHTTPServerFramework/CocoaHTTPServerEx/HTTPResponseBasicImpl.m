//
//  HTTPResponseBasicImpl.m
//  GLHTTPServerFramework
//
//  Created by NAG1-MAC-26584 on 22/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import "HTTPResponseBasicImpl.h"


@implementation HTTPResponseBasicImpl

-(id) initWithResponse:(GLHTTPResponse*)response
{
    if(self = [super init])
    {
        _response = response;
        return self;
    }
    return nil;
}

- (void)setResponse:(GLHTTPResponse*)response
{
    _response = response;
}

/**
 * Returns the length of the data in bytes.
 * If you don't know the length in advance, implement the isChunked method and have it return YES.
 **/
- (UInt64)contentLength
{
    if(_response)
    {
        return _response.data.length;
    }
    return 0;
}

/**
 * The HTTP server supports range requests in order to allow things like
 * file download resumption and optimized streaming on mobile devices.
 **/
- (UInt64)offset
{
    return _offset;
}

- (void)setOffset:(UInt64)offset
{
    _offset = offset;
}

/**
 * Returns the data for the response.
 * You do not have to return data of the exact length that is given.
 * You may optionally return data of a lesser length.
 * However, you must never return data of a greater length than requested.
 * Doing so could disrupt proper support for range requests.
 *
 * To support asynchronous responses, read the discussion at the bottom of this header.
 **/
- (NSData *)readDataOfLength:(NSUInteger)length
{
    NSData* data=nil;
    if(_response && _response.data && _offset < _response.data.length)
    {
        if(_offset +length >= _response.data.length)
        {
            NSRange rang = {_offset,_response.data.length-_offset};
            data = [_response.data subdataWithRange:rang];
            _offset = _response.data.length;
        }else
        {
            NSRange rang = {_offset,length+_offset};
            data = [_response.data subdataWithRange:rang];
            _offset += length;
        }
    }
    return data;
}

/**
 * Should only return YES after the HTTPConnection has read all available data.
 * That is, all data for the response has been returned to the HTTPConnection via the readDataOfLength method.
 **/
- (BOOL)isDone
{
    BOOL ret = YES;
    if(_response && _response.data)
    {
        if(_offset < _response.data.length)
            ret = NO;
    }
    return ret;
}

/**
 * If you need time to calculate any part of the HTTP response headers (status code or header fields),
 * this method allows you to delay sending the headers so that you may asynchronously execute the calculations.
 * Simply implement this method and return YES until you have everything you need concerning the headers.
 *
 * This method ties into the asynchronous response architecture of the HTTPConnection.
 * You should read the full discussion at the bottom of this header.
 *
 * If you return YES from this method,
 * the HTTPConnection will wait for you to invoke the responseHasAvailableData method.
 * After you do, the HTTPConnection will again invoke this method to see if the response is ready to send the headers.
 *
 * You should only delay sending the headers until you have everything you need concerning just the headers.
 * Asynchronously generating the body of the response is not an excuse to delay sending the headers.
 * Instead you should tie into the asynchronous response architecture, and use techniques such as the isChunked method.
 *
 * Important: You should read the discussion at the bottom of this header.
 **/
- (BOOL)delayResponeHeaders
{
    return NO;
}

/**
 * Status code for response.
 * Allows for responses such as redirect (301), etc.
 **/
- (NSInteger)status
{
    if(_response)
        return _response.statusCode;
    return 500;
}

/**
 * If you want to add any extra HTTP headers to the response,
 * simply return them in a dictionary in this method.
 **/
- (NSDictionary *)httpHeaders
{
    return _response.headersInfo;
}

/**
 * If you don't know the content-length in advance,
 * implement this method in your custom response class and return YES.
 *
 * Important: You should read the discussion at the bottom of this header.
 **/
- (BOOL)isChunked
{
    return NO;
}

/**
 * This method is called from the HTTPConnection class when the connection is closed,
 * or when the connection is finished with the response.
 * If your response is asynchronous, you should implement this method so you know not to
 * invoke any methods on the HTTPConnection after this method is called (as the connection may be deallocated).
 **/
- (void)connectionDidClose
{
    
}



@end
