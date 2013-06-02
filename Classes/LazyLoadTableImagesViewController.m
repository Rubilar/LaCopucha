//
//  LazyLoadTableImagesViewController.m
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 2/28/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import "LazyLoadTableImagesViewController.h"
#import "ParseOperation.h"
#import "ImageDownloader.h"
#define kCustomRowHeight    100.0
#define kCustomRowCount     1

static NSString *const xmlDataUrl =
@"http://itunes.apple.com/us/rss/topfreeapplications/limit=300/xml";
@implementation LazyLoadTableImagesViewController
@synthesize tableElements;
@synthesize queue;
@synthesize connection;
@synthesize xmlData;
@synthesize tView;
@synthesize imageDownloadsInProgress;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
	 self.tableElements=[[NSMutableArray alloc] init];
	  self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
 }
 return self;
 }


#pragma mark -
#pragma mark Table view creation (UITableViewDataSource)

// customize the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int count = [tableElements count];
	
	// ff there's no data yet, return enough rows to fill the screen
    if (count == 0)
	{
        return kCustomRowCount;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// customize the appearance of table view cells
	//
	
    static NSString *placeholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.tableElements count];
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:placeholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:placeholderCellIdentifier] autorelease];   
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
		
		cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }
	
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
	if (cell == nil) { 
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell"
																	owner:self options:nil];
		for (id oneObject in nib) if ([oneObject isKindOfClass:[CustomCell class]])
			cell = (CustomCell *)oneObject;
	}	
	// Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
        // Set up the cell...
        CellData *cellData = [self.tableElements objectAtIndex:indexPath.row];
        
		cell.name.text = cellData.name;
        cell.artist.text = cellData.artist;
		
        // Only load cached images; defer new downloads until scrolling ends
        if (!cellData.icon)
        {
            if (self.tView.dragging == NO && self.tView.decelerating == NO)
            {
                [self startIconDownload:cellData forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.itemImage.image = [UIImage imageNamed:@"Placeholder.png"];                
        }
        else
        {
			cell.itemImage.image = cellData.icon;
        }
		
    }
	
       
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kCustomRowHeight;

}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:xmlDataUrl]];
    self.connection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    
    // Test the validity of the connection object. 
    NSAssert(self.connection != nil, @"Failure to create URL connection.");

    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.xmlData = [NSMutableData data];    // start off with new data
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.xmlData appendData:data];  // append incoming data
}
#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Show Data"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([error code] == kCFURLErrorNotConnectedToInternet)
	{
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
															 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
        [self handleError:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleError:error];
    }
    
    self.connection = nil;   // release our connection
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.connection = nil;   // release our connection
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    
    // create the queue to run our ParseOperation
    self.queue = [[NSOperationQueue alloc] init];
	ParseOperation *operation = [[ParseOperation alloc] initWithData:self.xmlData delegate:self];
    
    [queue addOperation:operation]; // this will start the "ParseOperation"
    
    [operation release];
    

    self.xmlData = nil;
}
- (void)didFinishParsing:(NSArray *)cellDataList
{
    [self performSelectorOnMainThread:@selector(handleLoadedApps:) withObject:cellDataList waitUntilDone:NO];
    
    self.queue = nil;   // we are finished with the queue and our ParseOperation
}

- (void)parseErrorOccurred:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(handleError:) withObject:error waitUntilDone:NO];
}
- (void)handleLoadedApps:(NSArray *)loadedCellData
{
    [self.tableElements addObjectsFromArray:loadedCellData];
    
    // tell our table view to reload its data, now that parsing has completed
    [self.tView reloadData];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[tableElements release];
	[queue release];
	[connection release];
	[xmlData release];
	[tView release];
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(CellData *)cellData forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) 
    {
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.cellData = cellData;
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
        [imageDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.tableElements count] > 0)
    {
        NSArray *visiblePaths = [self.tView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            CellData *cellData = [self.tableElements objectAtIndex:indexPath.row];
            
            if (!cellData.icon) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:cellData forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil)
    {
        CustomCell *cell = [self.tView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.itemImage.image = imageDownloader.cellData.icon;
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}


@end
