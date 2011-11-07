#import <UIKit/UIKit.h>

@interface CellGame : UITableViewCell {
  UILabel* nameTeamOne;
  UILabel* nameTeamTwo;
  UILabel* pointsTeamOne;
  UILabel* pointsTeamTwo;
  UILabel* symbolResultTeamOne;
  UILabel* symbolResultTeamTwo;
  UILabel* dateLastPlayed;
}

@property (nonatomic, retain) IBOutlet UILabel* nameTeamOne;
@property (nonatomic, retain) IBOutlet UILabel* nameTeamTwo;
@property (nonatomic, retain) IBOutlet UILabel* pointsTeamOne;
@property (nonatomic, retain) IBOutlet UILabel* pointsTeamTwo;
@property (nonatomic, retain) IBOutlet UILabel* symbolResultTeamOne;
@property (nonatomic, retain) IBOutlet UILabel* symbolResultTeamTwo;
@property (nonatomic, retain) IBOutlet UILabel* dateLastPlayed;

@end