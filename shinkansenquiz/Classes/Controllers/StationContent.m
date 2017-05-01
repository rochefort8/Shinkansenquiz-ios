//
//  QuestionList.m
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/09/24.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import "StationContent.h"


@implementation StationContent

- (id)init
{
    self = [super init];
    if(self) {
        // Initialize Queue
        self.object = NULL ;
        self.board_image = NULL ;
        self.map_image = NULL ;
    }
    return self;
}

- (void)dealloc {
    //    [super dealloc];
}

- (NSString*)getName {
    return [self.object objectForKey:@"name"] ;
}

- (NSString*)getName_kanji {
    return [self.object objectForKey:@"name_kanji"] ;
}

- (NSString*)getName_kana {
    return [self.object objectForKey:@"name_kana"] ;
}

- (UIImage*)getBoardImage {
    return self.board_image ;
}

- (UIImage*)getMapImage {
    return self.map_image ;
}

@end
