//
//  main.c
//  PassUtil
//
//  Created by Globallogic on 13/03/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#include <stdio.h>
#include "PassSigner.h"
#include <CocoaHTTPServer/CocoaHTTPServer.h>
#include <stdlib.h>

#include "PSUtil.h"

#define SERVER_PORT 12345

void processHelp();
void processAddPass();

void info()
{
     printf("Server started at port 12345. Passes can be access using http://<ip>:SERVER_PORT/<abc.pass>\n");
}

int main(int argc, const char * argv[])
{
    system("clear");
    //verify all directory exists
    if(![PSUtil createDirectoryTreeIfNotExists:PASS_WORKINGDIR])
        return -1;
    if(![PSUtil createDirectoryTreeIfNotExists:PASS_PASSESDIR])
        return -1;
    if(![PSUtil createDirectoryTreeIfNotExists:PASS_PRIVATEDIR])
        return -1;
        
    HTTPServer* server = [[HTTPServer alloc]init];
    [server setType:@"_http._tcp."];
    [server setDocumentRoot:PASS_PASSESDIR];
    [server setPort:SERVER_PORT];
    NSError* error;
    if(![server start:&error])
    {
        NSLog(@"Couldn't start the server on port 12345, error: %@",[error description]);
        return -1;
    }
    info();
    printf(HELP);
    while(1)
    {
        printf("$ ");
        char optionLine[200];
        [PSUtil readLineFromConsole:optionLine size:200];

        NSString* option = [NSString stringWithUTF8String:optionLine];
        if([option hasPrefix:@"help"])
            processHelp();
        else if([option hasPrefix:@"add"])
            processAddPass();
        else if([option hasPrefix:@"exit"])
            break;
        else if([option hasPrefix:@"clear"])
            system("clear");
        else if([option hasPrefix:@"info"])
            info();
        else if([option length]>0)
            printf("Invalid Option: %s",optionLine);            
    }    
    return 0;
}
void processHelp()
{
    printf(HELP);
}
void processAddPass()
{
    char passName[100];
    char passDir[200];
    char certSuffix[100];
    
    printf("Enter pass Name: ");
    [PSUtil readLineFromConsole:passName size:100];

    printf("Enter path to pass Dir: ");
    [PSUtil readLineFromConsole:passDir size:200];
    NSString* passDirStr = [NSString stringWithUTF8String:passDir];
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:passDirStr])
    {
        printf("Path doesn't exists: %s",passDir);
        return;
    }
    
    printf("Provide certificate suffix, Leave blank, if suffix to be used from json.\nSuffix: ");
    [PSUtil readLineFromConsole:certSuffix size:100];
    NSString* suffix = nil;
    if(!strlen(certSuffix)==0)
        suffix = [NSString stringWithUTF8String:certSuffix];
     
    
    NSURL* inURL = [NSURL fileURLWithPath:passDirStr];
    NSURL* outURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%s.pkpass",PASS_PASSESDIR,passName]];
    
    if([PassSigner signPassWithURL:inURL certSuffix:suffix outputURL:outURL zip:YES])
        NSLog(@"\nPass %s.pkpass, created at: %@",passName,PASS_PASSESDIR);
    else
        NSLog(@"\n Couldn't create pass, see error above");
}



