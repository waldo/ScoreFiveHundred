//
//  GameViewController.m
//
//  Created by Ben Walsham on 23/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

static NSString *ssBiddingTeam = @"Bidding Team";
static NSString *ssBidAttempted = @"Bid Attempted";
static NSString *ssTricksWon = @"Tricks Won";
static NSString *ssTeamOneScore = @"Team One Score";
static NSString *ssTeamTwoScore = @"Team Two Score";

@synthesize roundsTableView;
@synthesize cellWrapper;
@synthesize teamOneName;
@synthesize teamTwoName;

@synthesize rounds;
@synthesize teamOneSlot;
@synthesize teamTwoSlot;


- (void) updateRound:(BOOL)updateRound ForTeamSlot:(NSNumber *)teamSlot ForHand:(NSString *) hand AndTricksWon:(NSNumber *)tricksWon {
  // TODO: update if this is an existing round
  
  // create a new round
  NSNumber *bidderPoints = [BidType biddersPointsForHand:hand AndBiddersTricksWon:tricksWon];
  NSNumber *nonBidderPoints = [BidType nonBiddersPointsForHand:hand AndBiddersTricksWon:tricksWon];

  int teamOneScore = 0;
  int teamTwoScore = 0;
  
  if ([self.rounds count] > 0) {
    // old total
    teamOneScore = [[[self.rounds objectAtIndex:0] valueForKey:ssTeamOneScore] intValue];
    teamTwoScore = [[[self.rounds objectAtIndex:0] valueForKey:ssTeamTwoScore] intValue];
    // plus current round score
  }

  if ([teamOneSlot isEqual:teamSlot]) {
    teamOneScore += [bidderPoints intValue];
    teamTwoScore += [nonBidderPoints intValue];
  }
  else {
    teamOneScore += [nonBidderPoints intValue];
    teamTwoScore += [bidderPoints intValue];
  }
  
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  
  [dict setObject:teamSlot forKey:ssBiddingTeam];
  [dict setObject:hand forKey:ssBidAttempted];
  [dict setObject:tricksWon forKey:ssTricksWon];
  [dict setObject:[NSNumber numberWithInt:teamOneScore] forKey:ssTeamOneScore];
  [dict setObject:[NSNumber numberWithInt:teamTwoScore] forKey:ssTeamTwoScore];
  
  [self.rounds insertObject:dict atIndex:0];
  
  NSLog(@"%@", self.rounds);
  
  [self.roundsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

  [dict release];
}

- (void) viewDidLoad {
  [super viewDidLoad];
  self.rounds = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"rounds"]];
  self.teamOneSlot = [NSNumber numberWithInt:0];
  self.teamTwoSlot = [NSNumber numberWithInt:1];
}

//
// UITableView delegate methods
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.rounds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CellScoringRound";
  
  CellScoringRound *cellScoringRound = (CellScoringRound *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellScoringRound == nil) {
    [cellWrapper loadMyNibFile:CellIdentifier];
    cellScoringRound = (CellScoringRound *)cellWrapper.cell;
  }
  
  NSLog(@"%@", indexPath);
  
  NSDictionary *round = [self.rounds objectAtIndex:indexPath.row];
  NSString *hand = [round valueForKey:ssBidAttempted];
  NSNumber *tricksWon = [round valueForKey:ssTricksWon];
  NSNumber *bidderPoints = [BidType biddersPointsForHand:hand AndBiddersTricksWon:tricksWon];
  NSNumber *nonBidderPoints = [BidType nonBiddersPointsForHand:hand AndBiddersTricksWon:tricksWon];
  
  NSNumber *bidderSlot = [round valueForKey:ssBiddingTeam];
  NSNumber *nonBidderSlot = [[round valueForKey:ssBiddingTeam] isEqual:teamOneSlot] ? teamTwoSlot : teamOneSlot;

  [cellScoringRound setStyleForBidderSlot:bidderSlot NonBidderSlot:nonBidderSlot WhenBidderWon:[BidType bidderWonHand:hand WithTricksWon:tricksWon] AndHandText:[BidType tricksAndSymbolForHand:hand] WithBidderTricksWon:tricksWon AndNonBidderTricksWon:[NSNumber numberWithInt:10 - [tricksWon intValue]] AndBidderPoints:bidderPoints AndNonBidderPoints:nonBidderPoints];
  
  cellScoringRound.pointsTeamOneLabel.text = [[round valueForKey:ssTeamOneScore] stringValue];
  cellScoringRound.pointsTeamTwoLabel.text = [[round valueForKey:ssTeamTwoScore] stringValue];

  return cellScoringRound;
}

- (NSString *) teamNameForSlot:(NSNumber *)slot {
  if ([slot isEqual:self.teamOneSlot]) {
    return self.teamOneName.text;
  }
  else {
    return self.teamTwoName.text;
  }
}

- (void) dealloc {
  [roundsTableView release];
  [cellWrapper release];
  [rounds release];
  
  [super dealloc];
}

@end
