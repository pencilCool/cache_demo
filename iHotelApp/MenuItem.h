//
//  MenuItem.h
//  iHotelApp
//
//  Created by Mugunth on 25/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

/*
 "id": "JAP122",			
 "image": "http://d1.myhotel.com/food_image1.jpg",
 "name": "Teriyaki Bento",
 "spicyLevel": 2,
 "rating" : 4,
 "description" : "Teriyaki Bento is one of the best lorem ipsum dolor sit",
 "waitingTime" : "930",
 "reviewCount" : 4
 */

@interface MenuItem : JSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *intro;


@end
