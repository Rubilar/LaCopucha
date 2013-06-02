//
//  LazyLoadTableImagesViewController.h
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 2/28/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellData.h"
#import "ParseOperation.h"
#import "ImageDownloader.h"
#import "CustomCell.h"
@interface LazyLoadTableImagesViewController : UIViewController<ParseOperationDelegate,ImageDownloaderDelegate> {
	NSMutableArray *tableElements;
	
	// the queue to run our "ParseOperation"
    NSOperationQueue *queue;     
    NSURLConnection *connection;
	NSMutableData *xmlData;
	
	UITableView *tView;
	NSMutableDictionary *imageDownloadsInProgress; 
}
@property (nonatomic, retain) NSMutableArray *tableElements;
@property (nonatomic, retain) NSOperationQueue *queue;    
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *xmlData;
@property (nonatomic, retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@end

