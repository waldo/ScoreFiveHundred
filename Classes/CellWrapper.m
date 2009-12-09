//
//  CellWrapper.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 09/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import "CellWrapper.h"


@implementation CellWrapper

@synthesize cell;

- (BOOL)loadMyNibFile:(NSString *)nibName {
  // Must be in same bundle as this class
  if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] == nil) {
    NSLog(@"Error, couldn't load %@ nib file.", nibName);
    return NO;
  }
  return YES;
}

@end
