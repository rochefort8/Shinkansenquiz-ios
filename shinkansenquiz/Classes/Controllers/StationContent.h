//
//  RouteContent.h
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/09/24.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#ifndef StationContent_h
#define StationContent_h

@interface StationContent : NSObject ;

@property (nonatomic,retain) PFObject *object ;
@property (nonatomic,retain) UIImage  *board_image ;
@property (nonatomic,retain) UIImage  *map_image ;

- (void)setObject:(PFObject*)data ;
- (NSString*)getName ;
- (NSString*)getName_kanji ;
- (NSString*)getName_kana ;

- (UIImage*)getBoardImage ;
- (UIImage*)getMapImage ;

@end

#endif /* QuestionListContent_h */
