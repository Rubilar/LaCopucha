//
//  CustomCell.m
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 3/7/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell
@synthesize itemImage,name,artist;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
	[itemImage release];
	[name release];
    [artist release];
}


@end
