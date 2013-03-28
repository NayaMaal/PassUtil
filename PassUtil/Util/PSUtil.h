//
//  PSUtil.h
//  PassUtil
//
//  Created by Globallogic on 20/03/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PASS_WORKINGDIR @"/usr/PassUtil"
#define PASS_PASSESDIR @"/usr/PassUtil/passes"
#define PASS_PRIVATEDIR @"/usr/PassUtil/private"

#define HELP "******************************************\
\nAvailabl Options: help, add, exit, clear, info\
\n******************************************\n"

typedef enum _OPTYPE
{
    OP_OPRND    =0,
    OP_MUL      =1,
    OP_DIV      =2,
    OP_ADD      =3,
    OP_SUB      =4,
    OP_LBR      =5,
    OP_RBR      =6
}OPTYPE;

@interface BODMASEntity : NSObject

@property (nonatomic,assign) OPTYPE     opType;
@property (nonatomic,retain) NSNumber*  opValue;

@end

@interface PSUtil : NSObject
{
    
}
+(double)evaluateExpression:(NSString*)statement;
+(double)evaluate:(NSString*)exp;
+(BOOL) createDirectoryTreeIfNotExists:(NSString*)path;
+(char*) readLineFromConsole:(char*)buffer size:(int)length;
@end
