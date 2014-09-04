//
//  SGKeyChain.h
//  SGKeyChainWrapper
//
//  Created by Sourav on 02/09/14.
//  Copyright (c) 2014 com.sourav.gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGKeyChain : NSObject

/**
 *  Shared keychain manager for whole app.
 *
 */
+ (SGKeyChain*)defaultKeyChain;

/* Save the dictionary in the key chain */
- (void)setDictionary:(NSDictionary*)dictioary forKey:(NSString *)key;

/* Delete the dictionary from the key chain */
- (void)deleteDictionaryForKey:(NSString *)key;

/* Retrieve the dictionary from the key chain */
- (NSDictionary *)dictionaryForKey:(NSString *)key;



@end
