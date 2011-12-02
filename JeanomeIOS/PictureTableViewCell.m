//
//  PictureTableViewCell.m
//  JeanomeIOS
//
//  Created by david lam on 11/22/11   .
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "PictureTableViewCell.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@implementation PictureTableViewCell

@synthesize closet;
@synthesize tableViewInsideCell;
@synthesize imageDownloadsInProgress;


- (void)dealloc {
    [tableViewInsideCell release];
    [super dealloc];
}

- (void) _logImageSize:(UIImage *)image atLine:(int)line
{
    size_t imageSize = CGImageGetBytesPerRow(image.CGImage) * CGImageGetHeight(image.CGImage);        
    NSLog(@"PictureTableViewcell.m:%d  imageSize: %zu", line, imageSize);
}

-(void)pictureTap:(id)target
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Tapped picture!" message:@"Wooo wooo" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

#pragma mark - Table view data source

/* 
    This should always be one.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

/*
    TODO  Return the number of photos in this category.
 */ 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [closet.closetItems count];
}

/*
    Get the photo from Jeanome and put it in the cell!
 */ 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // NSLog(@"Is%@ main thread", ([NSThread isMainThread] ? @"" : @" NOT"));

    NSUInteger row = indexPath.row;

    // NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell %u", row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    }
    
    // Since we are reusing the cells clear out the subviews from the old cell
//    for (UIImageView *view in cell.subviews) {
//        [view removeFromSuperview];
//    }
    
    NSLog(@"PictureTableViewCell.m:52   cellForRowAtIndexPath()  %u   reuse: %@   cell subview count: %u", row, cell.reuseIdentifier, [[cell.contentView subviews] count]);
    
    // 11/25/2011  This is weird but without this the cell frame isn't always the same size!
    //             Default view width is 320.  Default height is 1100.  106.66 is 320 / 3.0!
    // cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 106.666, 106.666);
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, screenWidth / 3.0 , screenWidth / 3.0);
    
    // Original - just show blue happy faces :D 
    //UIImage *closetItemImage = [UIImage imageNamed:@"babybluehappyface"];

    ClosetItem *closetItem = [[closet getClosetItemsArray] objectAtIndex:row];
    
    //  IMPORTANT,  clear out the other subviews or else they will stack on top of each other
    for(UIView *subView in [cell.contentView subviews]) {
        [subView removeFromSuperview];
    }
    
    // DEBUG - Just put label's of the image ID's
    /*
    UILabel *itemIdLabel = [[UILabel alloc] initWithFrame:cell.frame];
    itemIdLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(90)); 
    itemIdLabel.text = [NSString stringWithFormat:@"row %u #%@", row, closetItem.itemId];
    [cell.contentView addSubview:itemIdLabel];
    */
   
    // ASYNCHRNOUS IMAGE LOADING USING LazyTableImages METHOD, WEIRD RIGHT NOW
    if (!closetItem.image) {
        NSLog(@"PictureTableViewCell.m:83  closetItem image not cached... so download!");

        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:closetItem, @"closetItem", indexPath, @"indexPath", nil];
        
        [self startClosetPictureDownload:info];
        
        //[self performSelectorOnMainThread:@selector(startClosetPictureDownload:) withObject:info waitUntilDone:NO];
    }
    else {        
        NSLog(@"PictureTableViewCell.m:87  load cached closetImage at row %u  itemId: %@", indexPath.row, closetItem.itemId);
        
        closetItem.imageView.frame = cell.frame;        //  rotated in PictureDownloader.m:106
        //[cell.contentView addSubview:closetItem.imageView];
        
        cell.backgroundView = closetItem.imageView;
    }
    
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTap:)];
    
    [cell addGestureRecognizer:tgr];
    
    [tgr release];
                                   
    
    // SLOW NON-ASYNCHRONOUS IMAGE LOADING 
    /*
    // Fetch images from Jeanome/facebook to show
    NSArray *keys = [items allKeys];
     
    if (indexPath.row < [keys count]) {
        
        NSString *currKey = [keys objectAtIndex:indexPath.row];
        NSDictionary *imageDict = [items objectForKey:currKey];
        
        NSURL *imageURL = [NSURL URLWithString:[imageDict objectForKey:@"image"]];
        
        NSLog(@"PictureTableViewCell.m:70  downloading from imageURL: %@   cell.frame: %@   itemcount: %@", imageURL, NSStringFromCGRect(cell.frame), itemcount); 
        
        UIImage *closetItemImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        
        // DOSENT WORK
        //  UIImageView *iv = [[UIImageView alloc] initWithFrame:cell.frame]; 
        //iv.image = closetItemImage;        

        UIImageView *iv = [[UIImageView alloc] initWithImage:closetItemImage];
        
        iv.frame = cell.frame;
        
        // picture will be on its side, so rotate it up
        iv.transform = CGAffineTransformMakeRotation(degreesToRadians(90));     
        iv.contentMode = UIViewContentModeScaleToFill;
        
        [cell.contentView addSubview:iv];
        [iv release];
    }
     */

        
    return cell;
}

#pragma mark - Table view delegate


/* 
    This is the 'width' of each photo cell
 
    Total width of screen is 320.  Each photo is 110x110
 
    See ClosetViewController.m:206 in 
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


#pragma mark - Other stuff

/*
 Loads a UIImageView into cell.
 
 Use threads with this function!
 
 */
- (void) _loadClosetImage:intoCell:(UITableViewCell *)cell
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    

    [pool release];
}


#pragma mark -
#pragma mark Table cell image support

//- (void)startClosetPictureDownload:(ClosetItem *)closetItem forIndexPath:(NSIndexPath *)indexPath
- (void)startClosetPictureDownload:(NSDictionary *)info;
{
    NSIndexPath *indexPath = [info objectForKey:@"indexPath"];
    ClosetItem *closetItem = [info objectForKey:@"closetItem"];
    
    NSLog(@"PictureTableViewCell.m:165   startClosetPictureDownload()  %u", indexPath.row);
    
    PictureDownloader *pictureDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (pictureDownloader == nil) 
    {
        pictureDownloader = [[PictureDownloader alloc] init];
        pictureDownloader.closetItem = closetItem;
        pictureDownloader.indexPathInTableView = indexPath;
        pictureDownloader.delegate = self;
        [imageDownloadsInProgress setObject:pictureDownloader forKey:indexPath];
        [pictureDownloader startDownload];
        [pictureDownloader release];   
    }
}


// called by our PictureDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    PictureDownloader *pictureDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (pictureDownloader != nil)
    {
        // Image downloaded, so save it to the closet item's image and imageView
         
        // Display the newly loaded image  (rotated in PictureDownloader.m:106)

        UIImageView *iv = pictureDownloader.closetItem.imageView;

        NSLog(@"PictureTableViewCell.m:217   appImageDidLoad()  row: %u!   itemId: %@", indexPath.row, pictureDownloader.closetItem.itemId);
        
        /*
        if(indexPath.row == 1)
            iv.image = [UIImage imageNamed:@"babybluehappyface"];;
         */
        
        UITableViewCell *cell = [tableViewInsideCell cellForRowAtIndexPath:indexPath];

        /*
        NSLog(@"cell.frame: %@", NSStringFromCGRect(cell.frame)); 
        NSLog(@"cell.bounds: %@", NSStringFromCGRect(cell.bounds)); 
        */
        
        iv.frame = cell.frame;
        
        //iv.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 75, 75);   // testing
        
        //[cell.contentView addSubview:iv];
        
        cell.backgroundView = iv;
    }
    else {
        
        NSLog(@"PictureTableViewCell.m:237  XXX pictureDownloader at row %u was nil!", indexPath.row);
    }
}

/*

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    NSLog(@"PictureTableViewCell.m:232   loadImagesForOnscreenRows()");
    
    if ([closet.closetItems count] > 0)
    {
        NSArray *visiblePaths = [self.tableViewInsideCell indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ClosetItem *closetItem = [[closet getClosetItemsArray] objectAtIndex:indexPath.row];
            
            if (!closetItem.image) // avoid the app icon download if the app already has an icon
            {
                NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:closetItem, @"closetItem", indexPath, @"indexPath", nil];
                
                [self startClosetPictureDownload:info];
            }
            else {
                
                
                // NSLog(@"Should put cached image into  row: %u", indexPath.row);

                // ClosetItem *closetItem = [closetItems objectAtIndex:indexPath.row];
                
                // UITableViewCell *cell = [self.tableViewInsideCell cellForRowAtIndexPath:indexPath];
                // UIImageView *iv = [[UIImageView alloc] initWithImage:closetItem.image];
                // iv.frame = cell.frame;
                // [cell.contentView addSubview:iv];
                
                
            }
        }
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"PictureTableViewCell.m:233   scrollViewDidEndDragging()");
    
    if (!decelerate)
	{
//        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"PictureTableViewCell.m:243   scrollViewDidEndDragging()");
    
//    [self loadImagesForOnscreenRows];
}

*/
                     
@end
