//
//  MenuItem.m
//  iHotelApp
//
//  Created by Mugunth on 25/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import "MenuItem.h"
#import "Review.h"

@implementation MenuItem

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.

  }
  
  return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
}


-(void) setValue:(id)value forKey:(NSString *)key
{
  [super setValue:value forKey:key];
}

-(NSString*) description {
  
  return [NSString stringWithFormat:@"%@ - %@", self.title, self.intro];
}


//=========================================================== 
//  Keyed Archiving
//
//=========================================================== 
- (void)encodeWithCoder:(NSCoder *)encoder 
{
  [encoder encodeObject:self.title forKey:@"title"];
  [encoder encodeObject:self.intro forKey:@"intro"];
 
}

- (id)initWithCoder:(NSCoder *)decoder 
{
  self = [super init];
  if (self) {
    self.title = [decoder decodeObjectForKey:@"title"];
    self.intro = [decoder decodeObjectForKey:@"intro"];

  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
  
  [theCopy setTitle:[self.title copy]];
  [theCopy setIntro:[self.intro copy]];

  
  return theCopy;
}
@end
