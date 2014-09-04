//
//  SGKeyChain.m
//  SGKeyChainWrapper
//
//  Created by Sourav on 02/09/14.
//  Copyright (c) 2014 com.sourav.gupta. All rights reserved.
//

#import "SGKeyChain.h"

@implementation SGKeyChain

+ (SGKeyChain*)defaultKeyChain
{
    static SGKeyChain *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SGKeyChain alloc] init];
    });
    
    return sharedInstance;
}


- (void)setDictionary:(NSDictionary*)dictioary forKey:(NSString *)key {
    // serialize dict
    NSString *error;
    NSData *serializedDictionary = [NSPropertyListSerialization dataFromPropertyList:dictioary format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // encrypt in keychain
    if(!error) {
        // first, delete potential existing entries with this key (it won't auto update)
        [self deleteDictionaryForKey:key];
        
        // setup keychain storage properties
        NSDictionary *storageQuery = @{
                                       (__bridge id)kSecAttrAccount:    key,
                                       (__bridge id)kSecValueData:      serializedDictionary,
                                       (__bridge id)kSecClass:          (__bridge id)kSecClassGenericPassword,
                                       (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAlways
                                       };
        OSStatus osStatus = SecItemAdd((__bridge CFDictionaryRef)storageQuery, nil);
        if(osStatus != noErr) {
            // do someting with error
        }
    }
}

- (void)deleteDictionaryForKey:(NSString *)key {
    // setup keychain query properties
    NSDictionary *deletableItemsQuery = @{
                                          (__bridge id)kSecAttrAccount:        key,
                                          (__bridge id)kSecClass:              (__bridge id)kSecClassGenericPassword,
                                          (__bridge id)kSecMatchLimit:         (__bridge id)kSecMatchLimitAll,
                                          (__bridge id)kSecReturnAttributes:   (id)kCFBooleanTrue
                                          };
    
    CFTypeRef *arrayOfCFItemList;
    NSArray *itemList = nil;
    NSData *serializedDictionary = nil;
    OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef)deletableItemsQuery, (CFTypeRef *)&arrayOfCFItemList);
    if(osStatus == noErr)
    {
        serializedDictionary = (__bridge NSData *)(CFDataRef)arrayOfCFItemList;
        if ([serializedDictionary isKindOfClass:[NSArray class]]) {
            itemList = (NSArray*)serializedDictionary;
        }
        else if ([serializedDictionary isKindOfClass:[NSString class]]){
            if ([serializedDictionary length]) {
                itemList = [NSKeyedUnarchiver unarchiveObjectWithData:serializedDictionary];
            }
        }
    }
    // each item in the array is a dictionary
    for (NSDictionary *item in itemList) {
        NSMutableDictionary *deleteQuery = [item mutableCopy];
        [deleteQuery setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        // do delete
        osStatus = SecItemDelete((__bridge CFDictionaryRef)deleteQuery);
        if(osStatus != noErr) {
            // do something with error
        }
    }
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    // setup keychain query properties
    NSDictionary *readQuery = @{
                                (__bridge id)kSecAttrAccount: key,
                                (__bridge id)kSecReturnData: (id)kCFBooleanTrue,
                                (__bridge id)kSecClass:      (__bridge id)kSecClassGenericPassword
                                };
    
    NSData *serializedDictionary = nil;
    CFTypeRef *serializedDictionaryData;
    OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef)readQuery, (CFTypeRef *)&serializedDictionaryData);
    if(osStatus == noErr) {
        // deserialize dictionary
        NSString *error;
        serializedDictionary = (__bridge NSData *)(CFDataRef)serializedDictionaryData;
        NSDictionary *storedDictionary = [NSPropertyListSerialization propertyListFromData:serializedDictionary mutabilityOption:NSPropertyListImmutable format:nil errorDescription:&error];
        if(error) {
            NSLog(@"%@", error);
        }
        return storedDictionary;
    }
    else {
        // do something with error
        return nil;
    }
}


@end
