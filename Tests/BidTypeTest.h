#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "BidType.h"
#import "Team.h"

@interface BidTypeTest : SenTestCase {
  NSString* errorOut;
  NSManagedObjectContext* moc;
}

@property (nonatomic, retain) NSString* errorOut;
@property (nonatomic, retain) NSManagedObjectContext* moc;

- (void) checkForHand:(NSString*)hand withTeamOneTricksWon:(int)tricks teamOnePoints:(int)bidderExpectedPoints andTeamTwoPoints:(int)nonBidderExpectedPoints;

@end
