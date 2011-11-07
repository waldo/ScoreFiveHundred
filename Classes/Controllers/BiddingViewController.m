#import "BiddingViewController.h"
#import "ScoreFiveHundredAppDelegate.h"


@implementation BiddingViewController

// MARK: synthesize
@synthesize tricksWonController;
@synthesize bidSelectionTableView;
@synthesize cellWrapper;
@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize scoreTeamOne;
@synthesize scoreTeamTwo;

@synthesize bidTypeHands;
@synthesize game;
@synthesize biddingTeam;

- (void)dealloc {
  [tricksWonController release];
  [bidSelectionTableView release];
  [cellWrapper release];
  [nameTeamOne release];
  [nameTeamTwo release];
  [scoreTeamOne release];
  [scoreTeamTwo release];  

  [bidTypeHands release];
  [game release];
  [biddingTeam release];

  [super dealloc];
}

- (NSString*) hand {
  return [self.bidTypeHands objectAtIndex:[self.bidSelectionTableView indexPathForSelectedRow].row];
}

- (void) initWithGame:(Game*)g andTeam:(Team*)t {
  self.game = g;
  self.biddingTeam = t;
  
  NSString* possessive = nil;
  NSString* teamName = [self.biddingTeam name];

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

  self.nameTeamOne.text = [self.game nameForPosition:0];
  self.nameTeamTwo.text = [self.game nameForPosition:1];
  self.scoreTeamOne.text = [NSString stringWithFormat:@"%i pts", [self.game scoreForPosition:0]];
  self.scoreTeamTwo.text = [NSString stringWithFormat:@"%i pts", [self.game scoreForPosition:1]];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

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
  
  if ([[BidType suitColourForHand:key] isEqual:@"red" ]) {
    cellBidType.symbol.textColor = [UIColor redColor];
    cellBidType.symbol.highlightedTextColor = [UIColor redColor];
  }
  else if ([[BidType suitColourForHand:key] isEqual:@"black" ]) {
    cellBidType.symbol.textColor = [UIColor blackColor];
    cellBidType.symbol.highlightedTextColor = [UIColor blackColor];
  }
  
  cellBidType.description.text = [BidType descriptionForHand:key];
  cellBidType.points.text = [BidType pointsStringForHand:key];
  
  return cellBidType;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  [self.tricksWonController initWithGame:self.game team:self.biddingTeam andBid:[self hand]];
  [self.navigationController pushViewController:self.tricksWonController animated:YES];
}

@end