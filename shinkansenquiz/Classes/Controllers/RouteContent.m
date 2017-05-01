//
//  QuestionList.m
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/09/24.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import "RouteContent.h"

@interface RouteContent ()

@property (strong, nonatomic) NSMutableArray *objectList;
@property (strong, nonatomic) NSMutableArray *stationContentList;

@end

@implementation RouteContent

- (id)init
{
    self = [super init];
    if(self) {
        // Initialize Queue
        self.object = NULL ;
        self.image = NULL ;
        self.stationContentList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    //    [super dealloc];
}

- (NSString*)getName {
    return [self.object objectForKey:@"name"] ;
}

- (NSString*)getName_jp {
    return [self.object objectForKey:@"name_jp"] ;
}

- (NSString*)getStartingStation {
    return [self.object objectForKey:@"starting"] ;
}

- (NSString*)getTerminusStation {
    return [self.object objectForKey:@"terminus"] ;
}

- (UIImage*)getImage {
    return self.image ;
}

- (StationContent*)getStationContent:(int)position {
    return [self.stationContentList objectAtIndex:position] ;
}

- (int)getNumberOfStations {
    return (int)[self.stationContentList count] ;
}


- (void)loadData:(CallbackHandler)handler {
    
    NSString *className = [self getName] ;
    PFQuery *query = [PFQuery queryWithClassName:className];
//    [query orderByDescending:@"_created_at"];
    [query orderByAscending:@"index"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"[Station] Got them");
            
            
            NSMutableArray *latestList = [objects mutableCopy];
            bool updated = false ;
            if ([latestList count] == [self.objectList count]) {
                for (int i = 0;i < [latestList count];i++) {
                    PFObject *latest  = [latestList objectAtIndex:i] ;
                    PFObject *current = [self.objectList objectAtIndex:i] ;
                    if ([[latest objectId] isEqualToString:[current objectId]]) {
                        // Continue..
                    } else {
                        NSLog (@"String is different %@ / %@",[latest objectId],[current objectId]) ;
                        updated = true ;
                        break ;
                    }
                }
            } else {
                NSLog (@"Number is different") ;
                updated = true ;
            }
            
            // Reload view only when data had been really changed
            if (updated == true) {
                NSLog (@"[QuestionList] data updated, loading...") ;
                
                self.objectList = [objects mutableCopy];
            
                for (int i = 0;i < [self.objectList count];i++) {
                    PFObject *object = [self.objectList objectAtIndex:i] ;
                    NSLog(@"%@",[object objectForKey:@"name_kanji"]);
                }

                [self.stationContentList removeAllObjects] ;
                
                // Image
                for (int i = 0;i < [self.objectList count];i++) {
                    StationContent *content = [[StationContent alloc] init] ;
                    content.object = [self.objectList objectAtIndex:i] ;
                    [self.stationContentList addObject:content];
                }
            
                for (int i = 0;i < [self.stationContentList count];i++) {
                
                    StationContent *content = [self.stationContentList objectAtIndex:i] ;
                    PFObject *object = content.object;
                
                    PFFile *board_image = [object objectForKey:@"board_image"];
                
                    [board_image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error){
                            content.board_image = [UIImage imageWithData:data];
                        } else {
                            NSLog(@"no data!");
                        }
                        // FIXME !!
                        [self.stationContentList replaceObjectAtIndex:i withObject:content] ;
                    }];
                    
                    PFFile *map_image = [object objectForKey:@"map_image"];
                    
                    [map_image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error){
                            content.map_image = [UIImage imageWithData:data];
                        } else {
                            NSLog(@"no data!");
                        }
                        // FIXME !!
                        [self.stationContentList replaceObjectAtIndex:i withObject:content] ;
                    }];
                    
                    
                }
            } else {
                NSLog(@"[stationList] No updates found.") ;
            }
            if (handler) {
                handler(error) ;
            }
        }
        else {
            NSLog(@"[Station] Error");
        }
        if (handler) {
            handler(error) ;
        }
     }];
}


@end
