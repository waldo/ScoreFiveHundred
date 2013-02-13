#import "ScoreMiniViewController.h"


@interface ScoreMiniViewController()

- (void)refreshData;

@end

@implementation ScoreMiniViewController

- (void)initWithGame:(Game *)g {
  self.game = g;

  [self refreshData];
}

- (void)refreshData {
  _nameTeamOne.text = [_game nameForPosition:0];
  _nameTeamTwo.text = [_game nameForPosition:1];
  _scoreTeamOne.text = [NSString stringWithFormat:@"%d", [[_game scoreForPosition:0] intValue]];
  _scoreTeamTwo.text = [NSString stringWithFormat:@"%d", [[_game scoreForPosition:1] intValue]];
}

// MARK: View
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

@end
