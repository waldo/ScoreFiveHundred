#import "BiddingViewController.h"
#import "ScoreFiveHundredAppDelegate.h"


@implementation BiddingViewController

// MARK: synthesize
@synthesize
  tricksWonSummaryController,
  tricksWonController,
  bidSelectionTableView,
  cellWrapper,
  scoreController,
  bidTypeHands,
  game,
  round;

- (void)dealloc {
  [tricksWonSummaryController release];
  [tricksWonController release];
  [bidSelectionTableView release];
  [cellWrapper release];
  [scoreController release];

  [bidTypeHands release];
  [game release];
  [round release];

  [super dealloc];
}

- (NSString*) hand {
  return [self.bidTypeHands objectAtIndex:[self.bidSelectionTableView indexPathForSelectedRow].row];
}

- (void) initWithGame:(Game*)g andRound:(Round *)r {
  self.game = g;
  self.round = r;
  
  NSString* possessive = nil;
  NSString* teamName = [[self.round.biddingTeams anyObject] name];

  if ([[teamName substringFromIndex:[teamName length]-1] isEqual:@"s"]) {
    possessive = [NSString stringWithFormat:@"%@'", teamName];
  }
  else {
    possessive = [NSString stringWithFormat:@"%@'s", teamName];
  }
  
  self.title = [NSString stringWithFormat:@"%@ Bid", possessive];
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];

  self.bidTypeHands = [BidType orderedHands];

  [self.scoreController setStandardFrame];
  [self.view addSubview:self.scoreController.view];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.scoreController initWithGame:self.game];
  [self.bidSelectionTableView reloadData];
}

// MARK: tableview delegate
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bidTypeHands count];
}


- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellBidType";
  
  CellBidType* cellBidType = (CellBidType*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellBidType == nil) {
    [self.cellWrapper loadMyNibFile:CellIdentifier];
    cellBidType = (CellBidType*)self.cellWrapper.cell;
  }
  
  NSString* key = [self.bidTypeHands objectAtIndex:indexPath.row];
  
  cellBidType.symbol.text = [BidType tricksAndSymbolForHand:key];
  
  if ([[BidType suitColourForHand:key] isEqual:@"red"]) {
    cellBidType.symbol.textColor = [UIColor redColor];
    cellBidType.symbol.highlightedTextColor = [UIColor redColor];
  }
  else if ([[BidType suitColourForHand:key] isEqual:@"black"]) {
    cellBidType.symbol.textColor = [UIColor blackColor];
    cellBidType.symbol.highlightedTextColor = [UIColor blackColor];
  }
  
  cellBidType.description.text = [BidType descriptionForHand:key];
  cellBidType.points.text = [BidType pointsStringForHand:key];
  
  return cellBidType;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  Team* preferred = [self.game.teams firstObject];
  if ([self.round.biddingTeams count] > 0) {
    preferred = [self.round.biddingTeams anyObject];
  }
  
  self.round.bid = self.hand;
  [self.round updateAndSetTricksWon:[[BidType tricksForHand:self.hand] intValue] forTeam:preferred];

  if ([self.game.setting.mode isEqualToString:@"2 teams"] || [self.game.setting.mode isEqualToString:@"Quebec mode"] || [[BidType variation:self.hand] isEqualToString:@"misére"]) {
    [self.tricksWonController initWithGame:self.game round:self.round andTeam:preferred];
    [self.navigationController pushViewController:self.tricksWonController animated:YES];
  }
  else {
    [self.tricksWonSummaryController initWithGame:self.game andRound:self.round];
    [self.navigationController pushViewController:self.tricksWonSummaryController animated:YES];
  }
}

@end