//
//  ViewController.h
//  GLHTTPServerTestApp
//
//  Created by Ashish Ghulghule on 23/01/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLHTTPServerFramework/GLHTTPServerFramework.h>

@interface ViewController : UIViewController <GLHTTPRequestDelegate>
{
    BOOL isRegisterd;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)registerButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *echoBt;
@property (strong, nonatomic) IBOutlet UIButton *redirectBt;
@property (strong, nonatomic) IBOutlet UIButton *notfoundBt;
@property (strong, nonatomic) IBOutlet UIButton *postechoBt;
@property (nonatomic, retain) GLHTTPServer *httpServer;
@end
