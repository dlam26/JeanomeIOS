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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imageDownloadsInProgress = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    [items release];
    [tableViewInsideCell release];
    [imageDownloadsInProgress release];
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

//    NSLog(@"PictureTableViewCell.m:52   cellForRowAtIndexPath()  %u", indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
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


    
    
    // ASYNCHRNOUS LOADING USING LazyTableImages METHOD
    
    ClosetItem *closetItem = [closetItems objectAtIndex:indexPath.row];
    
    if (!closetItem.image) {
        NSLog(@"PictureTableViewCell.m:83  closetItem image not cached... so download!");
        [self startClosetPictureDownload:closetItem forIndexPath:indexPath];
        
        // FIXME  not working...
        UIActivityIndicatorView  *av = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        av.frame = cell.imageView.frame;
        [cell.imageView addSubview:av];
        [av startAnimating];
        
    }
    else {        
        NSLog(@"PictureTableViewCell.m:87  load cached closetImage at row %u", indexPath.row);
        //cell.imageView.image = closetItem.imageView.image;    // load cached image
        
        closetItem.imageView.frame = cell.frame;
        
        // picture will be on its side, so rotate it up
//        closetItem.imageView.transform = CGAffineTransformMakeRotation(degreesToRadians(90));     
//        closetItem.imageView.contentMode = UIViewContentModeScaleToFill;
        
        [cell.contentView addSubview:closetItem.imageView];
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

- (void)startClosetPictureDownload:(ClosetItem *)closetItem forIndexPath:(NSIndexPath *)indexPath
{
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
        // [pictureDownloader release];   
    }
}


// called by our PictureDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    NSLog(@"PictureTableViewCell.m:180   appImageDidLoad()  row: %u!", indexPath.row);

    PictureDownloader *pictureDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (pictureDownloader != nil)
    {
        // Display the newly loaded image  (rotated in PictureDownloader.m:106)

        UIImageView *iv = pictureDownloader.closetItem.imageView;
        
//        iv.transform = CGAffineTransformMakeRotation(degreesToRadians(90));     
//        iv.contentMode = UIViewContentModeScaleToFill;
        
        [self.contentView addSubview:iv];
    }
}



@end
