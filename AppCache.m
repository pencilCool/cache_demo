//
//  AppCache.m
//  iHotelApp
//
//  Created by tangyuhua on 2017/4/18.
//  Copyright © 2017年 Steinlogic. All rights reserved.
//

#import "AppCache.h"

@implementation AppCache

+ (void)initialize
{
    NSString *cacheDirectory = [AppCache cacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults]
                                    doubleForKey:@"CACHE_VERSION"];
    double currentAppVersion = [[AppCache appVersion] doubleValue];
    
    if( lastSavedCacheVersion == 0.0f || lastSavedCacheVersion <
       currentAppVersion)
    {
        [AppCache clearCache];
        // assigning current version to preference
        [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion
                                                  forKey:@"CACHE_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

+ (NSString *)cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    return cacheDirectory;
}


+ (NSArray *)getCachedMenuItems
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory
                             stringByAppendingPathComponent:@"MenuItems.archive"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:cachesDirectory]) {
        
        [fileManager createDirectoryAtPath:cachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSMutableArray *cachedItems = [NSKeyedUnarchiver
                                   unarchiveObjectWithFile:archivePath];
 
  
    return cachedItems;
  
}
+ (void)cacheMenuItems:(NSArray *)items
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"MenuItems.archive"];
    [NSKeyedArchiver archiveRootObject:items toFile:archivePath];
}

+ (BOOL)isMenuItemsStale {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory
                             stringByAppendingPathComponent:@"MenuItems.archive"];
    
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager]
                                       attributesOfItemAtPath:archivePath error:nil]
                                      fileModificationDate] timeIntervalSinceNow];
    return  (stalenessLevel > 13.0f);
}


+ (NSString *)appVersion
{
    CFStringRef versStr =
    (CFStringRef)CFBundleGetValueForInfoDictionaryKey
    (CFBundleGetMainBundle(), kCFBundleVersionKey);
    NSString *version = [NSString stringWithUTF8String:CFStringGetCStringPtr(versStr,kCFStringEncodingMacRoman)];
    return version;
                        

}


+ (void)clearCache
{
    NSArray *cacheItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[AppCache cacheDirectory] error:nil];
    for (NSString *path in cacheItems) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
}
@end
