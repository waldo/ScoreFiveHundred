#import "ScoreMiniViewController.h"


@interface ScoreMiniViewController()

@property UILabel *nameTeamOne;
@property UILabel *nameTeamTwo;
@property UILabel *scoreTeamOne;
@property UILabel *scoreTeamTwo;
@property Game *game;

- (void)refresh;

@end

@implementation ScoreMiniViewController

#pragma mark Public

- (void)initWithGame:(Game *)g {
  self.game = g;

  [self refresh];
}

#pragma mark Private

- (void)refresh {
  _nameTeamOne.text = [_game nameForPosition:0];
  _nameTeamTwo.text = [_game nameForPosition:1];
  _scoreTeamOne.text = [NSString stringWithFormat:@"%d", [[_game scoreForPosition:0] intValue]];
  _scoreTeamTwo.text = [NSString stringWithFormat:@"%d", [[_game scoreForPosition:1] intValue]];
}

#pragma mark View

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

@end
