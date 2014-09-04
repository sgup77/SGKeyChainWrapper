//
//  SGHelper.m
//  SGKeyChainWrapper
//
//  Created by Sourav on 02/09/14.
//  Copyright (c) 2014 com.sourav.gupta. All rights reserved.
//

#import "SGHelper.h"

@implementation SGHelper

+(NSString *)removeSpaceCharactersFromStart:(NSString *)string{
    
    NSString *untrimedString = string;
    NSString *trimedString = [untrimedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return trimedString;
}


@end
