#import <Foundation/Foundation.h>
#import "Team.h"

@interface BidType : NSObject {

}

+ (NSArray*) orderedHands;
+ (NSDictionary*) allTypes;
+ (NSString*) suitColourForHand:(NSString*)hand;
+ (NSString*) tricksAndSymbolForHand:(NSString*)hand;
+ (NSString*) tricksAndDescriptionForHand:(NSString*)hand;
+ (NSString*) descriptionForHand:(NSString*)hand;
+ (NSString*) pointsStringForHand:(NSString*)hand;
+ (NSNumber*)pointsForTeam:(Team*)t biddingTeams:(NSOrderedSet*)biddingTeams withHand:(NSString*)hand andTricksWon:(NSNumber*)tricksWon;
+ (BOOL) bidderWonHand:(NSString*)hand WithTricksWon:(NSNumber*)tricksWon;
+ (NSString*) variation:(NSString*)hand;

@end
