//
//  GLHTTPServer.m
//  GLHTTPServerFramework
//
//  Created by Ashish Ghulghule on 21/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//
#import <CocoaHTTPServer/CocoaHTTPServer.h>
#import "GLHTTPServer.h"
#import "HTTPServerEx.h"
#import "GLHTTPRequestDelegate.h"
#import "GLHTTPConnection.h"


@interface GLHTTPServer ()

@property (nonatomic, strong) HTTPServerEx      *httpServer;
@property (nonatomic, strong) HTTPConfigEx      *httpConfig;

-(BOOL) addHandler: (id <GLHTTPRequestDelegate>) delegate forUri:(NSString *) uri isDir:(BOOL)isDir;

@end

@implementation GLHTTPServer
@synthesize httpServer = _httpServer;

+ (GLHTTPServer *) sharedInstance
{
    static GLHTTPServer *globalInstance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        globalInstance = [[self alloc] init];
    });
    return globalInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.httpServer = [[HTTPServerEx alloc] init];
        [self.httpServer setConnectionClass:[GLHTTPConnection class]];
        
        // Tell the server to broadcast its presence via Bonjour.
        // This allows browsers such as Safari to automatically discover our service.
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setInterface:@"loopback"];
        
        // Normally there's no need to run our server on any specific port.
        // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
        // However, for easy testing you may want force a certain port so you can just hit the refresh button.
        //[_httpServer setPort:11122];
        
        // Serve files from our embedded Web folder
        //NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
        //[_httpServer setDocumentRoot:webPath];
        
        self.httpConfig = [[HTTPConfigEx alloc]init];
        [_httpServer setConfig:_httpConfig];
        
        // register for foreground and backgrournd events so that server can be stopped or resumed accordingly.
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

-(BOOL)isRunning
{
    return [_httpServer isRunning];
}

-(UInt16)port
{
    return [_httpServer port];
}

-(BOOL) addHandler: (id <GLHTTPRequestDelegate>) delegate forUri:(NSString *) uri isDir:(BOOL)isDir
{
    GLRequestConfig *config = [[GLRequestConfig alloc] initWithUri:uri andDelegate:delegate];
    config.isDirectory = isDir;
    // This is to add / if delegate has not added it in the uri.
    if(![config.uri hasPrefix:@"/"])
    {
        config.uri = [NSString stringWithFormat:@"/%@",uri];
    }
    
    if(![self.httpConfig addUriConfig:config])
        return NO;
    
    // only start server if atleast one delegate is registred.
    if ([[self.httpConfig allUris] count])
    {
         NSLog(@"http server is starting");
        [self.httpServer start:nil];
    }
    return YES;
}

-(BOOL) registerDelegate: (id <GLHTTPRequestDelegate>) delegate forUri:(NSString *) uri
{
    return [self addHandler:delegate forUri:uri isDir:NO];
}

-(BOOL) registerDelegate: (id <GLHTTPRequestDelegate>) delegate forDir:(NSString *)dir
{
    return [self addHandler:delegate forUri:dir isDir:YES];
}


-(void) unregisterDelegate: (id <GLHTTPRequestDelegate>) delegate forPath:(NSString *) uri
{
    if(![uri hasPrefix:@"/"])
    {
        uri = [NSString stringWithFormat:@"/%@",uri];
    }
    [self.httpConfig removeUriConfigForPath:uri];
    
    //stop server if no delegates are registed.
    if (![[self.httpConfig allUris]count])
    {
        NSLog(@"http server is stopped");
        [self.httpServer stop];
    }
}

// need to stop server when app enteres in background
-(void) applicationDidEnterBackground
{
     NSLog(@"http server is stopped");
    [self.httpServer stop];
}

// need to start server when app enteres in foreground based on count of registered delegates.
-(void) applicationWillEnterForeground
{
    if (![[self.httpConfig allUris]count])
    {
         NSLog(@"http server is starting");
        [self.httpServer start:nil];
    }
}


@end
