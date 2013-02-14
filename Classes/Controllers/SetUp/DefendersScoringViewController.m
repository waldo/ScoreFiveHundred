#import "DefendersScoringViewController.h"


@interface DefendersScoringViewController ()

@property IBOutlet UISwitch *nonBidderScoresTen;
@property IBOutlet UISwitch *onlySuccessfulDefendersScore;
@property NSArray *capOptions;

- (IBAction)nonBidderScoresTen:(id)sender;
- (IBAction)onlySuccessfulDefendersScore:(id)sender;

- (void)refresh;

@end

@implementation DefendersScoringViewController

#pragma mark Public

- (void)initWithSetting:(Setting *)s {
  self.setting = s;
  self.capOptions = @[@0, @400, @460, @490];
}

#pragma mark Private

- (IBAction)nonBidderScoresTen:(id)sender {
  _setting.nonBidderScoresTen = @(((UISwitch *)sender).on);

  [self refresh];
}

- (IBAction)onlySuccessfulDefendersScore:(id)sender {
  _setting.onlySuccessfulDefendersScore = @(((UISwitch *)sender).on);

  [self refresh];
}

- (void)refresh {
  [_nonBidderScoresTen setOn:_setting.nonBidderScoresTen.boolValue];
  [_onlySuccessfulDefendersScore setOn:_setting.onlySuccessfulDefendersScore.boolValue];

  [self.tableView reloadData];
}


#pragma mark View

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self refresh];
}

#pragma mark Tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (_setting.nonBidderScoresTen.boolValue) {
    return 3;
  }

	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

  if (indexPath.section == 2) {
    cell.accessoryType = UITableViewCellAccessoryNone;

    if (indexPath.row == 0) {
      if (_setting.capDefendersScore.intValue == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
      }
    }
    else {
      if ([[NSString stringWithFormat:@"%@ points", _setting.capDefendersScore] isEqualToString:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
      }
    }
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 2) {
    _setting.capDefendersScore = _capOptions[indexPath.row];
  }

  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self refresh];
}

@end
