//
//  PSUtil.m
//  PassUtil
//
//  Created by Globallogic on 20/03/13.
//  Copyright (c) 2013 Globallogic. All rights reserved.
//

#import "PSUtil.h"

@implementation BODMASEntity

@synthesize opType;
@synthesize opValue;

-(NSString*)description
{
    switch (self.opType) {
        case OP_OPRND:
            return [NSString stringWithFormat:@"%@",self.opValue];
        case OP_ADD:
            return [NSString stringWithUTF8String:"+"];
        case OP_SUB:
            return [NSString stringWithUTF8String:"-"];
        case OP_MUL:
            return [NSString stringWithUTF8String:"*"];
        case OP_DIV:
            return [NSString stringWithUTF8String:"/"];
        case OP_LBR:
            return [NSString stringWithUTF8String:"("];
        case OP_RBR:
            return [NSString stringWithUTF8String:")"];
    }
    return [NSString stringWithUTF8String:"Invalid entity"];    
}

@end

@implementation PSUtil
+(BOOL) createDirectoryTreeIfNotExists:(NSString*)path
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError* error;
        if(![[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Error in creating dir: %@ error:%@",path,[error description]);
            return NO;
        }
    }
    return YES;
}

+(char*) readLineFromConsole:(char*)buffer size:(int)length
{
    fgets(buffer, length, stdin);
    int i=0,j=0;
    while(buffer[i]==' ' || buffer[i]=='\n' || buffer[i]=='\r')
        i++;
    while(buffer[j]!='\0')
    {
        buffer[j] = buffer[j+i];
        j++;
    }
    j=j-i-1;//current length
    while(j>0 && (buffer[j]==' ' || buffer[j]=='\n' || buffer[j]=='\r'))
        j--;
    buffer[j+1]='\0';
    return buffer;
}

+(OPTYPE)OPTYPE:(char)ch
{
    switch(ch)
    {
        case '(':
            return OP_LBR;
        case ')':
            return OP_RBR;
        case '*':
            return OP_MUL;
        case '/':
            return OP_DIV;
        case '-':
            return OP_SUB;
        case '+':
            return OP_ADD;
    }
    return OP_OPRND;
}

+(BODMASEntity*)getOPTYPE:(char)ch
{
    BODMASEntity* entity = [[BODMASEntity alloc]init];
    OPTYPE type = [self OPTYPE:ch];
    entity.opType = type;
    return entity;
}

+(BODMASEntity*)getOperandEntity:(NSString*)numricString
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* value = [f numberFromString:numricString];
    BODMASEntity* ent = [[BODMASEntity alloc]init];
    ent.opType = OP_OPRND;
    ent.opValue = value;
    return ent;
}

+(NSArray*)tokenizeExpression:(NSString*)statement
{
    //extract expressions
    NSMutableArray* ops=[NSMutableArray array];
    NSMutableString* buffer = [NSMutableString string];
    NSUInteger i=0, len=[statement length];
    while(i<len)
    {
        BODMASEntity* entity = [self getOPTYPE:[statement characterAtIndex:i]];
        if(entity.opType !=OP_OPRND)
        {
            if([buffer length]>0)
            {
                [ops addObject:[self getOperandEntity:buffer]];
                buffer = [NSMutableString string];//reset buffer
            }
            [ops addObject:entity];
        }
        else
            [buffer appendFormat:@"%c",[statement characterAtIndex:i]];
        i++;
    }
    if([buffer length]>0)
    {
        [ops addObject:[self getOperandEntity:buffer]];
    }
    return ops;
}
+(NSArray*)doAS:(NSArray*)stack
{
    NSMutableArray* table = [NSMutableArray array];
    for (int i=0; i<stack.count; i++) {
        BODMASEntity* entity = [stack objectAtIndex:i];
        OPTYPE op = entity.opType;
        if(op != OP_OPRND)
        {
            if(op == OP_ADD || op == OP_SUB)
            {
                BODMASEntity* op1 = [table lastObject];
                BODMASEntity* op2 = [stack objectAtIndex:i+1];
                double val = 0.0;
                if(op == OP_ADD)
                    val = [op1.opValue doubleValue]+[op2.opValue doubleValue];
                else
                    val = [op1.opValue doubleValue]-[op2.opValue doubleValue];
                [table removeLastObject];
                BODMASEntity* nEnt = [[BODMASEntity alloc]init];
                nEnt.opType = OP_OPRND;
                nEnt.opValue = [NSNumber numberWithDouble:val];
                [table addObject:nEnt];
                i++;
                continue;
            }
        }
        [table addObject:entity];
    }
    return table;
}

+(NSArray*)doDM:(NSArray*)stack
{
    NSMutableArray* table = [NSMutableArray array];
    for (int i=0; i<stack.count; i++) {
        BODMASEntity* entity = [stack objectAtIndex:i];
        OPTYPE op = entity.opType;
        if(op != OP_OPRND)
        {
            if(op == OP_DIV || op == OP_MUL)
            {
                BODMASEntity* op1 = [table lastObject];
                BODMASEntity* op2 = [stack objectAtIndex:i+1];
                double val = 0.0;
                if(op == OP_DIV)
                    val = [op1.opValue doubleValue]/[op2.opValue doubleValue];
                else
                    val = [op1.opValue doubleValue]*[op2.opValue doubleValue];
                [table removeLastObject];
                BODMASEntity* nEnt = [[BODMASEntity alloc]init];
                nEnt.opType = OP_OPRND;
                nEnt.opValue = [NSNumber numberWithDouble:val];
                [table addObject:nEnt];
                i++;
                continue;
            }
        }
        [table addObject:entity];
    }
    return table;
}

+(void)verifyExp:(NSArray*)ops
{
    int lbr=0,rbr=0,opratorCount=0,operandCount=0;
    for (BODMASEntity* op in ops) {
        switch (op.opType) {
            case OP_OPRND:
                operandCount++;
                break;
            case OP_ADD:
            case OP_MUL:
            case OP_SUB:
            case OP_DIV:
                opratorCount++;
                break;
            case OP_LBR:
                lbr++;
                break;
            case OP_RBR:
                rbr++;
                break;
        }
        if(rbr > lbr)
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid braces placement" userInfo:nil];
    }
    if(operandCount != (opratorCount+1))
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid number of operators" userInfo:nil];
}
+(double)evaluateBODMAS:(NSArray*)stack
{
    NSMutableArray* tokens = [NSMutableArray array];
    NSMutableArray* leftBracesPositions = [NSMutableArray array];
    for(int i=0; i<stack.count; i++)
    {
        BODMASEntity* ent = [stack objectAtIndex:i];
        if(ent.opType == OP_RBR)
        {
            NSNumber* pos = (NSNumber*)[leftBracesPositions lastObject];
            if(pos == nil)
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Close bracket without open bracket" userInfo:nil];
            [leftBracesPositions removeLastObject];
            int lastValPos = [pos intValue]+1;
            NSRange rang = {lastValPos,tokens.count - lastValPos};
            NSIndexSet* idx = [[NSIndexSet alloc]initWithIndexesInRange:rang];
            NSArray* bexp = [tokens objectsAtIndexes:idx];
            NSLog(@"%@",[bexp description]);
            double val = [self calculate:bexp];
            BODMASEntity* nEnt = [[BODMASEntity alloc]init];
            nEnt.opType = OP_OPRND;
            nEnt.opValue = [NSNumber numberWithDouble:val];
            rang.location--;
            rang.length++;
            [tokens removeObjectsInRange:rang];
            [tokens addObject:nEnt];
        }
        else
        {
            if(ent.opType == OP_LBR)
            {
                NSNumber* pos = [NSNumber numberWithInt:(int)tokens.count];
                [leftBracesPositions addObject:pos];
            }
            [tokens addObject:ent];
        }
    }
    return [self calculate:tokens];
}
+(double)calculate:(NSArray*)tokens
{
    tokens = [self doDM:tokens];
    NSLog(@"ops: %@",[tokens description]);
    tokens = [self doAS:tokens];
    NSLog(@"ops: %@",[tokens description]);
    if(tokens.count > 1)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Invalid exp: %@",tokens] userInfo:nil];
    return [((BODMASEntity*)[tokens lastObject]).opValue doubleValue];
}

+(double)evaluateExpression:(NSString*)statement
{
    NSArray* tokens = [self tokenizeExpression:statement];
    [self verifyExp:tokens];
    NSLog(@"ops: %@",[tokens description]);
    return [self evaluateBODMAS:tokens];
}

+(double)evaluate:(NSString*)statement
{
    NSArray* tokens = [self tokenizeExpression:statement];
    [self verifyExp:tokens];
    NSLog(@"ops: %@",[tokens description]);
//multiplication and devisions
    tokens = [self doDM:tokens];
    NSLog(@"ops: %@",[tokens description]);
//additon and substractions
    tokens = [self doAS:tokens];
    NSLog(@"ops: %@",[tokens description]);
    if(tokens.count > 1)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Invalid exp: %@",statement] userInfo:nil];
    return [((BODMASEntity*)[tokens lastObject]).opValue doubleValue];
}

//+(double)evaluate1:(NSString*)exp
//{
//    //extract expressions
//    NSMutableArray* ops=[NSMutableArray array];
//    NSMutableString* buffer = [NSMutableString string];
//    NSUInteger i=0, len=[exp length];
//    NSRange range;    
//    while(i<len)
//    {
//        if([self OPTYPE:[exp characterAtIndex:i]] !=OP_OPRND)
//        {
//            if([buffer length]>0)
//            {
//                [ops addObject:buffer];
//                buffer = [NSMutableString string];
//            }
//            range.length = 1; range.location=i;
//            [ops addObject:[exp substringWithRange:range]];
//        }
//        else
//            [buffer appendFormat:@"%c",[exp characterAtIndex:i]];
//        i++;
//    }
//    [self verifyExp:ops];
//    NSLog(@"ops: %@",[ops description]);
//    return 0;
//}
//+(double)evaluateDMAS:(NSArray*)stack
//{
//    return 0;
//}
//
//+(double)evaluateBO:(NSArray*)stack
//{
//    NSMutableArray* expStack = [NSMutableArray array];
//    NSInteger expStart=-1;
//    for(int i=0; i< stack.count; i++)
//    {
//        NSString* exp = [stack objectAtIndex:i];
//        OPTYPE op = [self OPTYPE:[exp characterAtIndex:0]];
//        if(op ==OP_LBR)
//        {
//            expStart = i;
//        }
//        if(op == OP_RBR)
//        {
//            if(expStart == -1)
//               @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid right bracket ')'" userInfo:nil];
//            NSRange rang = {expStart+1,i-expStart-1};
//            NSIndexSet* iset = [NSIndexSet indexSetWithIndexesInRange:rang];
//            NSArray* bracketExp = [expStack objectsAtIndexes:iset];
//            double val = [self evaluateDMAS:bracketExp];
//            rang.location = expStart;
//            rang.length = expStack.count - expStart;
//            [expStack removeObjectsInRange:rang];
//            [expStack addObject:[NSString stringWithFormat:@"%f",val]];
//        }
//        else
//            [expStack addObject:exp];
//        
//    }
//    return 0;
//}
//
@end
