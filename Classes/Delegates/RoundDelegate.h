#import <Foundation/Foundation.h>

@protocol RoundDelegate <NSObject>

- (void)cancelRoundForGame:(Game *)g fromController:(UIViewController *)controller;
- (void)applyRoundForGame:(Game *)g fromController:(UIViewController *)controller;

@end
