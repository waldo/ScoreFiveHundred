#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "BidType.h"
#import "Game.h"
#import "Round.h"
#import "Team.h"

@interface BidTypeTest : SenTestCase {
  NSString* errorOut;
  NSManagedObjectContext* moc;
  NSDictionary* settings;
}

@property (nonatomic, retain) NSString* errorOut;
@property (nonatomic, retain) NSManagedObjectContext* moc;
@property (nonatomic, retain) NSDictionary* settings;

- (void) checkWithSetting:(Setting*)setting forHand:(NSString*)hand withTeamOneTricksWon:(int)tricks teamOnePoints:(int)bidderExpectedPoints andTeamTwoPoints:(int)nonBidderExpectedPoints;

@end
