//
//  Closet.m
//  JeanomeIOS
//
//  Created by David Lam on 11/16/11.
//  Copyright (c) 2011 Home. All rights reserved.
//
//
//  See jeanome/api/views.py:17 closet()
//

#import "Closet.h"

@implementation Closet
    
@synthesize closetInfo, closetItems;


-(id)initWithJSON:(NSString *)json
{    
    // NSLog(@"Closet.m:20   initWithJSON(): %@", json);
    
    self = [super init];    
    if(self) {    
        self.closetInfo = [json JSONValue];
        
        //  From the JSON dict in closetInfo, store a dict of the ClosetItem objects so we 
        //  can store fetched images in it
        self.closetItems = [NSMutableDictionary dictionary];
        
        NSDictionary *itemsFromJSON = [self.closetInfo objectForKey:@"items"];
        
        // NSDecimalNumber *itemCount = [self.closetInfo objectForKey:@"itemcount"];
        
        if(itemsFromJSON) {        
            // Translate the dict made from JSON into ClosetItem objects
            for(NSString* itemId in [itemsFromJSON allKeys]) {
                NSDictionary *imageDict = [itemsFromJSON objectForKey:itemId];
                ClosetItem *ci = [[ClosetItem alloc] initWithImageDict:imageDict andId:itemId];
                [self.closetItems setObject:ci forKey:itemId];
                [ci release];
            }
        }
    }
    
    return self;
}

-(NSString *)__defaultWith:(NSString *)aDefault ifThisIsNull:(id)val
{
    if(val == NULL)
        return aDefault;
    else
        return val;
}

-(NSString *)getName
{
    return [self.closetInfo objectForKey:@"name"];
}

-(NSString *)getSquarePhoto
{
    return [self.closetInfo objectForKey:@"square_photo"];
}

-(NSString *)getFollowers
{
//    NSLog(@"Closet.m:46  getFollowers(): %@", [self.closetInfo objectForKey:@"followers"]);
  
    return [self __defaultWith:@"0" ifThisIsNull:[self.closetInfo objectForKey:@"followers"]];
    
//    return [self.closetInfo objectForKey:@"followers"];
}

-(NSString *)getFollowing
{
    return [self __defaultWith:@"0" ifThisIsNull:[self.closetInfo objectForKey:@"following"]];
}

-(NSString *)getStatus
{
    return [self __defaultWith:@"None" ifThisIsNull:[self.closetInfo objectForKey:@"status"]];
}

-(NSDecimalNumber *)getPoints
{
    //NSLog(@"Closet.m:34  getPoints(): %@", [self.closetInfo objectForKey:@"points"]);
    
    // return [self.closetInfo objectForKey:@"points"];
    
    //  if "points" is a string...
    //return [NSDecimalNumber decimalNumberWithString:[self __defaultWith:@"0" ifThisIsNull:[self.closetInfo objectForKey:@"points"]]];

    NSDecimalNumber *points = [self.closetInfo objectForKey:@"points"];    
    if(points == NULL)
        return 0;
    else
        return points;
}


/*
    Similar to getItems, but returns an array of ClosetItem objects so that 
    PictureTablewViewCell can load cached images in ClosetItem's image property
 */ 
-(NSArray *)getClosetItemsArray
{
    NSArray *itemIds = [closetItems allKeys];    
    NSMutableArray *closetItemsArray = [[[NSMutableArray alloc] init] autorelease];
    
    for(NSString* itemId in itemIds)
        [closetItemsArray addObject:[closetItems objectForKey:itemId]];
    
    return [NSArray arrayWithArray:closetItemsArray];
}

-(void)setClosetItem:(ClosetItem *)closetItem forItemId:(NSString *)itemId
{
    [closetItems setObject:closetItems forKey:itemId];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Closet.m:120   didSelectRowAtIndexPath()  %u", indexPath.row);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Closet.m:108   cellForRowAtIndexPath()");
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Pic #%u", indexPath.row];
    
    return cell;
}


@end
