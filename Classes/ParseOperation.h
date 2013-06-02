//
//  ParseOperation.h
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 2/28/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CellData;
@protocol ParseOperationDelegate;
@interface ParseOperation : NSOperation<NSXMLParserDelegate> {
	id <ParseOperationDelegate> delegate;    
    NSData *dataToParse;    
    NSMutableArray *workingArray;
    CellData *cellData;
	NSMutableString *workingPropertyString;
	NSArray *elementsToParse;
    BOOL storingCharacterData;


}
@property (nonatomic, assign) id <ParseOperationDelegate> delegate;
@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) NSMutableArray *workingArray;
@property (nonatomic, retain) CellData *cellData;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSArray *elementsToParse;
@property (nonatomic, assign) BOOL storingCharacterData;
- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate;
@end
@protocol ParseOperationDelegate
- (void)didFinishParsing:(NSArray *)appList;
- (void)parseErrorOccurred:(NSError *)error;
@end