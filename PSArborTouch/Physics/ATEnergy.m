//
//  ATEnergy.m
//  PSArborTouch
//
//  Created by Ed Preston on 19/09/11.
//  Copyright 2011 Preston Software. All rights reserved.
//

#import "ATEnergy.h"


@interface ATEnergy ()
// reserved
@end


@implementation ATEnergy

@synthesize sum     = sum_;
@synthesize max     = max_;
@synthesize mean    = mean_;
@synthesize count   = count_;

- (id) init
{
    self = [super init];
    if (self) {
        sum_    = 0.0;
        max_    = 0.0;
        mean_   = 0.0;
        count_  = 0;
    }
    return self;
}


#pragma mark - Internal Interface


@end
