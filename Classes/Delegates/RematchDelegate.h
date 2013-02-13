#import <Foundation/Foundation.h>

@protocol RematchDelegate <NSObject>

- (void)rematchForGame:(Game *)g fromController:(UIViewController *)controller;

@end
