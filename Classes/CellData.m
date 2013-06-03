//
//  CellData.m
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 2/28/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import "CellData.h"


@implementation CellData
@synthesize name,summary,date,icon,iconUrl;

- (void)dealloc
{
[name release];
[date release];
[icon release];
[iconUrl release];
[summary release];

[super dealloc];
}
@end
