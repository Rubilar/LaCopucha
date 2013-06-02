//
//  CellData.m
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 2/28/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import "CellData.h"


@implementation CellData
@synthesize name,artist,icon,iconUrl;

- (void)dealloc
{
[name release];
[artist release];
[icon release];
[iconUrl release];

[super dealloc];
}
@end
