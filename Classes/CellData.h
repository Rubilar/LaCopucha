//
//  CellData.h
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 2/28/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CellData : NSObject {
	NSString *name;
    NSString *summary;
    NSString *date;
	UIImage *icon;
	NSString *iconUrl;
    

}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSString *iconUrl;
@end
