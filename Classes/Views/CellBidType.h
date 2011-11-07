#import <UIKit/UIKit.h>

@interface CellBidType : UITableViewCell {
  UILabel* symbol;
  UILabel* description;
  UILabel* points;
}

@property (nonatomic, retain) IBOutlet UILabel* symbol;
@property (nonatomic, retain) IBOutlet UILabel* description;
@property (nonatomic, retain) IBOutlet UILabel* points;

@end
