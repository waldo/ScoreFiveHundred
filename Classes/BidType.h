//
//  BidType.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 29/11/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidType : NSObject {

}

+ (NSArray *)orderedKeys;
+ (NSDictionary *)allTypes;
+ (NSString *)suitColourForKey:(NSString *)key;
+ (NSString *)tricksAndSymbolForKey:(NSString *)key;
+ (NSString *)descriptionForKey:(NSString *)key;
+ (NSString *)pointsForKey:(NSString *)key;

@end