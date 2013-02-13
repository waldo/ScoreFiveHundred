#import <Foundation/Foundation.h>
#import "Game.h"
#import "Setting.h"
#import "Round.h"
#import "Team.h"

@interface BidType : NSObject

+ (NSArray *)orderedHands;
+ (NSDictionary *)allTypes;
+ (NSString *)suitColourForHand:(NSString *)hand;
+ (NSNumber *)tricksForHand:(NSString *)hand;
+ (NSString *)tricksAndSymbolForHand:(NSString *)hand;
+ (NSString *)tricksAndDescriptionForHand:(NSString *)hand;
+ (NSString *)descriptionForHand:(NSString *)hand;
+ (NSString *)pointsStringForHand:(NSString *)hand withGame:(Game *)g;
+ (NSInteger)pointsForTeam:(Team *)t game:(Game *)g andTricksWon:(NSUInteger)tricksWon;
+ (BOOL)bidderWonHand:(NSString *)hand withTricksWon:(NSUInteger)tricksWon;
+ (NSString *)variation:(NSString *)hand;

@end
