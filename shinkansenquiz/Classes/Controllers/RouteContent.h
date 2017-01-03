//
//  RouteContent.h
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/09/24.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#ifndef RouteContent_h
#define RouteContent_h

#import "StationContent.h"


@interface RouteContent : NSObject ;

@property (nonatomic,retain) PFObject *object ;
@property (nonatomic,retain) UIImage  *image ;

typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

- (void)setObject:(PFObject*)data ;
- (NSString*)getName ;
- (NSString*)getName_jp ;
- (NSString*)getStartingStation ;
- (NSString*)getTerminusStation ;

- (void)setImage:(UIImage*)data ;
- (UIImage*)getImage ;

- (StationContent*)getStationContent:(int)position ;
- (int)getNumberOfStations ;

@end

#endif /* QuestionListContent_h */
