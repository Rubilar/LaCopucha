//
//  IconDownloader.h
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 2/28/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CellData;


@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSObject
{
    CellData *cellData;
    NSIndexPath *indexPathInTableView;
    id <ImageDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) CellData *cellData;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol ImageDownloaderDelegate 

- (void)imageDidLoad:(NSIndexPath *)indexPath;

@end