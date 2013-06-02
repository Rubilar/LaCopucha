//
//  ParseOperation.m
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 2/28/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import "ParseOperation.h"
#import "CellData.h"

// string contants found in the RSS feed
static NSString *kIDStr     = @"id";
static NSString *kNameStr   = @"im:name";
static NSString *kImageStr  = @"im:image";
static NSString *kArtistStr = @"im:artist";
static NSString *kEntryStr  = @"entry";

@implementation ParseOperation
@synthesize delegate, dataToParse, workingArray,cellData,workingPropertyString,elementsToParse, storingCharacterData;

- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate
{
    self = [super init];
    if (self != nil)
    {
        self.dataToParse = data;
        self.delegate = theDelegate;
		self.elementsToParse = [NSArray arrayWithObjects:kIDStr, kNameStr, kImageStr, kArtistStr, nil];

    }
    return self;
}


- (void)dealloc {
    [dataToParse release];
    [cellData release];
	[workingPropertyString release];
    [workingArray release];
    
    [super dealloc];
}
- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.workingArray = [NSMutableArray array];
	self.workingPropertyString = [NSMutableString string];
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not
	// desirable because it gives less control over the network, particularly in responding to
	// connection errors.
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParse];
	[parser setDelegate:self];
    [parser parse];
	if (self.delegate!=nil)
    {
		[self.delegate didFinishParsing:self.workingArray];
    }
	    
    self.workingArray = nil;
 
    self.dataToParse = nil;
    
    [parser release];
	
	[pool release];
}
- (void)parserDidStartDocument:(NSXMLParser *)parser{	
	
}



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	if ([elementName isEqualToString:kEntryStr] ) {
		self.cellData = [[[CellData alloc] init] autorelease];
		
	}
	 storingCharacterData = [elementsToParse containsObject:elementName];
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if (self.cellData)
	{
        if (storingCharacterData)
        {
            NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:kImageStr])
            {
                self.cellData.iconUrl = trimmedString;
            }
            else if ([elementName isEqualToString:kNameStr])
            {        
                self.cellData.name = trimmedString;
            }
            else if ([elementName isEqualToString:kArtistStr])
            {
                self.cellData.artist = trimmedString;
            }
                    }
        else if ([elementName isEqualToString:kEntryStr] ) {
			[self.workingArray addObject:self.cellData];
			self.cellData=nil;
		}
    }
    
	
	
	
	
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterData)
    {
        [workingPropertyString appendString:string];
    }
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [delegate parseErrorOccurred:parseError];
}

@end
