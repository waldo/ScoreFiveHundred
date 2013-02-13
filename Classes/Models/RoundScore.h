#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round, Team;

@interface RoundScore : NSManagedObject

@property NSNumber *score;
@property NSNumber *tricksWon;
@property Round *round;
@property Team *team;

@end
