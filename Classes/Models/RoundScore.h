#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round, Team;

@interface RoundScore : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * tricksWon;
@property (nonatomic, retain) Round *round;
@property (nonatomic, retain) Team *team;

@end
