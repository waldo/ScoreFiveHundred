#import "BiddingViewController.h"


@interface BiddingViewController ()

@property NSArray *bidTypeHands;
@property Game *game;
@property Round *round;

- (NSString *)hand;
- (void)setBidAndSegueToController:(TricksWonViewController *)controller;

@end

@implementation BiddingViewController

#pragma mark Public

- (void)initWithGame:(Game *)g {
  self.game = g;
  self.round = g.currentRound;
  
  NSString *teamName = [_round.biddingTeams.anyObject name];

  self.title = [NSString stringWithFormat:@"%@ Bid", teamName];
}

#pragma mark Private

- (NSString *)hand {
  // consider whether misère and nullo are included or excluded
  return _bidTypeHands[self.tableView.indexPathForSelectedRow.row];
}

- (void)setBidAndSegueToController:(TricksWonViewController *)controller {
  Team *biddingTeam = [_round.biddingTeams anyObject];

  _round.bid = self.hand;
  [_round setTricksWon:[[BidType tricksForHand:self.hand] intValue] forTeam:biddingTeam];

  [controller initWithGame:_game andTeam:biddingTeam];
  controller.delegate = self.delegate;
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ScoreSummary"]) {
    [((ScoreMiniViewController *)segue.destinationViewController) initWithGame:_game];
  }
  else if ([segue.identifier isEqualToString:@"RegularBid"]) {
    [self setBidAndSegueToController:segue.destinationViewController];
  }
  else if ([segue.identifier isEqualToString:@"MisèreBid"]) {
    [self setBidAndSegueToController:segue.destinationViewController];
  }
}

#pragma mark View

- (void)viewDidLoad {
  [super viewDidLoad];

  self.bidTypeHands = [BidType orderedHands];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.tableView reloadData];
}

#pragma mark Tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // consider whether misère and nullo are included or excluded
  return self.bidTypeHands.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

  // show or hide misère and nullo bids

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

  if ([cell.reuseIdentifier isEqualToString:@"MisèreBidType"]) {
    [self performSegueWithIdentifier:@"MisèreBid" sender:cell];
  }
  else {
    [self performSegueWithIdentifier:@"RegularBid" sender:cell];
  }
}

@end
