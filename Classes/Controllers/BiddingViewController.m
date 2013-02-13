#import "BiddingViewController.h"


@interface BiddingViewController ()

- (NSString *)hand;
- (void)setBidAndSegueToController:(TricksWonViewController *)controller;

@end

@implementation BiddingViewController

- (void) initWithGame:(Game*)g {
  self.game = g;
  self.round = g.currentRound;
  
  NSString *teamName = [_round.biddingTeams.anyObject name];

  self.title = [NSString stringWithFormat:@"%@ Bid", teamName];
}

// MARK: Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ScoreSummary"]) {
    [((ScoreMiniViewController *)segue.destinationViewController) initWithGame:_game];
  }
  else if ([segue.identifier isEqualToString:@"RegularBid"]) {
    [self setBidAndSegueToController:segue.destinationViewController];
  }
  else if ([segue.identifier isEqualToString:@"MiséreBid"]) {
    [self setBidAndSegueToController:segue.destinationViewController];
  }
}

// MARK: View
- (void)viewDidLoad {
  [super viewDidLoad];

  self.bidTypeHands = [BidType orderedHands];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.tableView reloadData];
}

// MARK: tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // consider whether misére and nullo are included or excluded
  return self.bidTypeHands.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

  // show or hide misére and nullo bids

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

  if ([cell.reuseIdentifier isEqualToString:@"MiséreBidType"]) {
    [self performSegueWithIdentifier:@"MiséreBid" sender:cell];
  }
  else {
    [self performSegueWithIdentifier:@"RegularBid" sender:cell];
  }
}

// MARK: hidden
- (NSString *)hand {
  // consider whether misére and nullo are included or excluded
  return _bidTypeHands[self.tableView.indexPathForSelectedRow.row];
}

- (void)setBidAndSegueToController:(TricksWonViewController *)controller {
  Team *biddingTeam = [_round.biddingTeams anyObject];

  _round.bid = self.hand;
  [_round setTricksWon:[[BidType tricksForHand:self.hand] intValue] forTeam:biddingTeam];

  [controller initWithGame:_game andTeam:biddingTeam];
  controller.delegate = self.delegate;
}

@end
