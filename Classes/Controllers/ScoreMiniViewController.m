#import "ScoreMiniViewController.h"

@implementation ScoreMiniViewController


// MARK: synthesize
@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize scoreTeamOne;
@synthesize scoreTeamTwo;


- (void) dealloc {
  [nameTeamOne release];
  [nameTeamTwo release];
  [scoreTeamOne release];
  [scoreTeamTwo release];

  [super dealloc];
}

- (void) initWithGame:(Game*)g {
  self.nameTeamOne.text = [g nameForPosition:0];
  self.nameTeamTwo.text = [g nameForPosition:1];
  self.scoreTeamOne.text = [NSString stringWithFormat:@"%d pts", [[g oldScoreForPosition:0] intValue]];
  self.scoreTeamTwo.text = [NSString stringWithFormat:@"%d pts", [[g oldScoreForPosition:1] intValue]];
}

- (void) setStandardFrame {
  [self.view setFrame:CGRectMake(0, self.view.bounds.size.height - 43, 320, 44)];
}

// MARK: view
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
