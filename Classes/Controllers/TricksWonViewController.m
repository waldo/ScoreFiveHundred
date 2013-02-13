#import "TricksWonViewController.h"


@implementation TricksWonViewController

static int siMaximumTricks = 10;

- (void)initWithGame:(Game *)g andTeam:(Team *)t {
  self.game = g;
  self.round = g.currentRound;
  self.team = t;
  self.bidVariation = [BidType variation:_round.bid];

  self.title = [NSString stringWithFormat:@"%@", _team.name];
}

// MARK: Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ScoreSummary"]) {
    [((ScoreMiniViewController *)segue.destinationViewController) initWithGame:_game];
  }
}

// MARK: View
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.tableView reloadData];
}

// MARK: tableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  int tricksWon = (siMaximumTricks - indexPath.row);
  int score = [BidType pointsForTeam:self.team game:self.game andTricksWon:tricksWon];
    
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%i pts", score];
  if (score < 0) {
    [cell.detailTextLabel setTextColor:[UIColor redColor]];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  int tricksWon = (siMaximumTricks - indexPath.row);

  [self.round setTricksWon:tricksWon forTeam:self.team];
  [self.game finaliseRound];
  [self.delegate applyRoundForGame:self.game fromController:self];
}

@end
