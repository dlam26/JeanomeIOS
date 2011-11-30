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

@synthesize tableViewInsideCell, items, closetItems, itemcount;
@synthesize imageDownloadsInProgress;


- (void)dealloc {
    [items release];
    [tableViewInsideCell release];
    [super dealloc];
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
    return [itemcount integerValue];
}

/*
    Get the photo from Jeanome and put it in the cell!
 */ 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // NSLog(@"Is%@ main thread", ([NSThread isMainThread] ? @"" : @" NOT"));

    
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;

    // NSLog(@"PictureTableViewCell.m:52   cellForRowAtIndexPath()  %u  %u", row, section);
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell %u", row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    // 11/25/2011  This is weird but without this the cell frame isn't always the same size!
    //             Default view width is 320.  Default height is 1100.  106.66 is 320 / 3.0!
    // 
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 106.666, 106.66);
    
    // Original - just show blue happy faces :D 
    //UIImage *closetItemImage = [UIImage imageNamed:@"babybluehappyface"];

    
    ClosetItem *closetItem = [closetItems objectAtIndex:row];
    
    // DEBUG - Just put label's of the image ID's
    /*
    UILabel *itemIdLabel = [[UILabel alloc] initWithFrame:cell.frame];
    itemIdLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(90)); 
    itemIdLabel.text = [NSString stringWithFormat:@"%u.) #%@", row, closetItem.itemId];
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
        //cell.imageView.image = closetItem.imageView.image;    // load cached image
        
        closetItem.imageView.frame = cell.frame;
        
        // picture will be on its side, so rotate it up
//        closetItem.imageView.transform = CGAffineTransformMakeRotation(degreesToRadians(90));     
//        closetItem.imageView.contentMode = UIViewContentModeScaleToFill;
        
        [cell.contentView addSubview:closetItem.imageView];
        [cell setNeedsDisplay];
    }
     
    
    
    
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
    NSLog(@"PictureTableViewCell.m:217   appImageDidLoad()  row: %u!", indexPath.row);

    PictureDownloader *pictureDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (pictureDownloader != nil)
    {
        // Display the newly loaded image  (rotated in PictureDownloader.m:106)

        UIImageView *iv = pictureDownloader.closetItem.imageView;

        size_t imageSize = CGImageGetBytesPerRow(iv.image.CGImage) * CGImageGetHeight(iv.image.CGImage);
        
        NSLog(@"PictureTableViewCell.m:228   imageSize: %zu", imageSize);
        
        UITableViewCell *cell = [tableViewInsideCell cellForRowAtIndexPath:indexPath];
        iv.frame = cell.frame;
        [cell.contentView addSubview:iv];
    
        //[self.contentView addSubview:iv];
    }
    else {
        
        NSLog(@"PictureTableViewCell.m:237  pictureDownloader at row %u was nil!", indexPath.row);
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"PictureTableViewCell.m:233   scrollViewDidEndDragging()");
    
    if (!decelerate)
	{
//        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"PictureTableViewCell.m:243   scrollViewDidEndDragging()");
    
//    [self loadImagesForOnscreenRows];
}



@end
