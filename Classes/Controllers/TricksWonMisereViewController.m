#import "TricksWonMisereViewController.h"


@implementation TricksWonMisereViewController

#pragma mark Tableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  long score = 0;
  long tricksWon = 0;

  tricksWon = indexPath.row;
  score = [BidType pointsForTeam:self.team game:self.game andTricksWon:tricksWon];

  cell.detailTextLabel.text = [NSString stringWithFormat:@"%li pts", score];
  if (score < 0) {
    cell.detailTextLabel.textColor = [UIColor redColor];
  }
  else {
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.21960784310000001f green:0.3294117647f blue:0.52941176469999995f alpha:1.0f];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  long tricksWon = indexPath.row;

  [self.round setTricksWon:tricksWon forTeam:self.team];
  self.round.complete = [NSNumber numberWithBool:YES];
  [self.game finaliseRound];
  [self.delegate applyRoundForGame:self.game fromController:self];
}

@end
