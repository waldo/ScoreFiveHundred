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

+ (NSArray *) orderedHands;
+ (NSDictionary *) allTypes;
+ (NSString *) suitColourForHand:(NSString *)hand;
+ (NSString *) tricksAndSymbolForHand:(NSString *)hand;
+ (NSString*) tricksAndDescriptionForHand:(NSString*)hand;
+ (NSString *) descriptionForHand:(NSString *)hand;
+ (NSString *) pointsStringForHand:(NSString *)hand;
+ (NSNumber *) biddersPointsForHand:(NSString *)hand AndBiddersTricksWon:(NSNumber *)tricksWon;
+ (NSNumber *) nonBiddersPointsForHand:(NSString *)hand AndBiddersTricksWon:(NSNumber *)tricksWon;
+ (BOOL) bidderWonHand:(NSString *)hand WithTricksWon:(NSNumber *)tricksWon;
+ (NSString*) variation:(NSString*)hand;

@end
