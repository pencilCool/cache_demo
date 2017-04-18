//
//  AppCache.m
//  iHotelApp
//
//  Created by tangyuhua on 2017/4/18.
//  Copyright © 2017年 Steinlogic. All rights reserved.
//

#import "AppCache.h"

@implementation AppCache
//
//+ (NSString *)archivePath
//{
//    static NSString *path;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//    });
//    
//    return path;
//}

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
@end
