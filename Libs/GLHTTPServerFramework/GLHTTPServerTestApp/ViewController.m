//
//  ViewController.m
//  GLHTTPServerTestApp
//
//  Created by Ashish Ghulghule on 23/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize httpServer = _httpServer;
@synthesize echoBt;
@synthesize notfoundBt;
@synthesize redirectBt;
@synthesize postechoBt;


- (void)viewDidLoad
{
    isRegisterd = false;
    [super viewDidLoad];

    self.httpServer = [GLHTTPServer sharedInstance];
    [self.httpServer registerDelegate:self forDir:@"testDir"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(GLHTTPResponse *) handleRequest:(GLHTTPRequest *) request
{
    GLHTTPResponse *response = nil;
    if([request.uri hasPrefix:@"/testDir/myname.txt"])
    {
        response = [[GLHTTPResponse alloc] initWitStatusCode:200 data:[request.uri dataUsingEncoding:NSUTF8StringEncoding]];
    }else if([request.uri hasPrefix:@"/testDir/postSample.txt"])
    {
        response = [[GLHTTPResponse alloc] initWitStatusCode:200 data:request.data];
    }
    else if([request.uri hasPrefix:@"/testDir/redirect.txt"])
    {
        response = [[GLHTTPResponse alloc] initWitStatusCode:302 data:request.data];
        NSDictionary* dic = [NSDictionary dictionaryWithObject:@"http://www.google.com/" forKey:@"Location"];
        response.headersInfo = dic;
    }
    else
    {
        response = [[GLHTTPResponse alloc] initWitStatusCode:404 data:[@"resource not found" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    return response;
}

- (IBAction)registerButtonClicked:(id)sender
{
    isRegisterd = !isRegisterd;
    
    if(sender == self.echoBt)
    {
        NSString *urlString = [NSString stringWithFormat:@"http://localhost:%d/testDir/myname.txt?name=hi",[self.httpServer port]];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];        
    }else if(sender == notfoundBt)
    {
        NSString *urlString = [NSString stringWithFormat:@"http://localhost:%d/testDir/notFound.txt",[self.httpServer port]];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];        
    }else if(sender == postechoBt)
    {
        NSString* html = @"<form name=\"input\" action=\"postSample.txt\" method=\"post\">\nUsername: <input type=\"text\" name=\"user\">\n\
        <input type=\"submit\" value=\"Submit\">\
        </form>";
        
        NSString *urlString = [NSString stringWithFormat:@"http://localhost:%d/testDir/",[self.httpServer port]];
        [self.webView loadData:[html dataUsingEncoding:NSUTF8StringEncoding] MIMEType:@"text/html" textEncodingName:@"utf8" baseURL:[NSURL URLWithString:urlString]];
    }else if(sender == self.redirectBt)
    {
        NSString *urlString = [NSString stringWithFormat:@"http://localhost:%d/testDir/redirect.txt?name=hi",[self.httpServer port]];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];        
    }
}
@end
