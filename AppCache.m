//
//  AppCache.m
//  iHotelApp
//
//  Created by tangyuhua on 2017/4/18.
//  Copyright © 2017年 Steinlogic. All rights reserved.
//

#import "AppCache.h"

static NSMutableDictionary *memeoryCache;
static NSMutableArray *recentlyAccessedKey;
static int kCacheMemoryLimit;

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveMemoryCacheToDisk:)
                                                 name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveMemoryCacheToDisk:)
                                                 name: UIApplicationWillTerminateNotification object:nil];
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
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self
                                                       dataForFile:@"MenuItems.archive"]];

}
+ (void)cacheMenuItems:(NSArray *)items
{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:items] toFile:@"MenuItems.archive"];
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"MenuItems.archive"];
    [NSKeyedArchiver archiveRootObject:items toFile:archivePath];
}

+ (void) cacheData: (NSData *)data toFile: (NSString *)fileName {
    [memeoryCache setObject:data forKey:fileName];
    if ([recentlyAccessedKey containsObject:fileName]) {
        [recentlyAccessedKey removeObject:fileName];
    }
    [recentlyAccessedKey insertObject:fileName atIndex:0];
    if ([recentlyAccessedKey count] > kCacheMemoryLimit) {
        NSString *leastRecentlyUsedDataFilename = [recentlyAccessedKey lastObject];
        NSData *leastRecentlyUsedCacheData = [memeoryCache objectForKey:leastRecentlyUsedDataFilename];
        NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
        [leastRecentlyUsedCacheData writeToFile:archivePath atomically:YES];
        [recentlyAccessedKey removeLastObject];
        [memeoryCache removeObjectForKey:leastRecentlyUsedDataFilename];

    }
}

+(NSData*) dataForFile:(NSString*) fileName
{
    NSData *data = [memeoryCache objectForKey:fileName];
    if (data) {
        return data;
    }
    NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
    data = [NSData dataWithContentsOfFile:archivePath];
    if (data) {
        [self cacheData:data toFile:fileName];
    }
    return data;
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

+ (void)saveMemoryCacheToDisk
{
    for (NSString *fileName in [memeoryCache allKeys]) {
        NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
        NSData *cacheData = [memeoryCache objectForKey:fileName];
        [cacheData writeToFile:archivePath atomically:YES];
    }
    [memeoryCache removeAllObjects];
}
@end
