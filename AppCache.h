//
//  AppCache.h
//  iHotelApp
//
//  Created by tangyuhua on 2017/4/18.
//  Copyright © 2017年 Steinlogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject

+ (NSString *)cachesDirectory;

+ (NSArray *)getCachedMenuItems;
+ (void)cacheMenuItems:(NSArray *)items;

+ (BOOL ) isMenuItemsStale;

+ (void) clearCache;
@end
