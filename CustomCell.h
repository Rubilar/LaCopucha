//
//  CustomCell.h
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 3/7/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
	
	UIImageView *itemImage;
	UILabel *name;
    UILabel *date;
    UILabel *summary;
	

}
@property (nonatomic,retain) IBOutlet UIImageView *itemImage;
@property (nonatomic,retain) IBOutlet UILabel *name;
@property (nonatomic,retain) IBOutlet UILabel *summary;
@property (nonatomic,retain) IBOutlet UILabel *date;
@end
