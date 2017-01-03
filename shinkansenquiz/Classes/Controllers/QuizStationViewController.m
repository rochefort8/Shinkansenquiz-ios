//
//  QuizStationViewController.m
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/12/26.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import "QuizStationViewController.h"
#import "HomeViewController.h"

@interface QuizStationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *boardImage;
@property (weak, nonatomic) IBOutlet UIImageView *mapImage;
@property (weak, nonatomic) IBOutlet UIButton *answer1Button;
@property (weak, nonatomic) IBOutlet UIButton *answer2Button;
@property (weak, nonatomic) IBOutlet UIButton *answer3Button;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *commentText;

@property int currentPosition ;

- (void)updateView ;
- (void)swap123:(int *)table pos_1:(int)a pos_2:(int)b ;
- (void)onAnswer:(int)answer ;

@property(nonatomic) AVAudioPlayer *audioPlayer_correct, *audioPlayer_wrong;

@end

@implementation QuizStationViewController

@synthesize routeContent = _routeContent ;

#define NUMBER_OF_ANSWERS (3)

int answers[NUMBER_OF_ANSWERS] ;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPosition =  0;
    [self initAudio];
    [self updateView] ;
}


- (void)initAudio
{
    NSError *error ;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Quiz_correct" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer_correct = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer_correct.numberOfLoops = 0 ;
    if ( error != nil ) {
        NSLog(@"Error %@", [error localizedDescription]);
    }
    path = [[NSBundle mainBundle] pathForResource:@"Quiz_wrong" ofType:@"mp3"];
    url = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer_wrong = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer_wrong.numberOfLoops = 0 ;
    if ( error != nil ) {
        NSLog(@"Error %@", [error localizedDescription]);
    }
}


- (void)updateView {
    StationContent *station = [self.routeContent getStationContent:self.currentPosition] ;
    
    self.navigationItem.title = [station getName_kanji] ;
    self.boardImage.image = [station getBoardImage ] ;
    
    //
    
    int numberOfStations = [self.routeContent getNumberOfStations];
    
    NSLog(@"# of stations=%d",numberOfStations);
    int next = self.currentPosition + 1 ;
    int close_to_the_next ;

    if (next < numberOfStations - 2) {
        /* ... curent, next, close, .... or
         ... curent, next, xxx, close, ... */
        close_to_the_next = next + 1 + ((uint64_t)arc4random() % 2)  ;
    } else {
        if (next == numberOfStations - 2) {
            
            /* ... curent, next, close */
            close_to_the_next = next + 1 ;
        } else {
            
            /* ... , close, curent, next, ... */
            close_to_the_next = self.currentPosition - 1;
        }
    }
    answers [0] = next ;
    answers [1] = close_to_the_next ;
    
    int table[numberOfStations] ;
    
    // Table init
    for (int i = 0;i < numberOfStations;i++) {
        table[i] = i ;
    }
    [self swap123:table pos_1:0 pos_2:self.currentPosition ];
    [self swap123:table pos_1:1 pos_2:next ];
    [self swap123:table pos_1:2 pos_2:close_to_the_next] ;

    /* Remained answers is selected by random sequence */
    for (int i = 0;i < NUMBER_OF_ANSWERS-2;i++) {
        int j = 3 + i + ((uint64_t)arc4random() % (numberOfStations-3)) ;
        answers[2+i] = table[j] ;
    }
    
    /* Shuffle answer position */
    for (int i = 0; i < NUMBER_OF_ANSWERS;i++) {
        int j = i + ((uint64_t)arc4random() % (NUMBER_OF_ANSWERS - i)) ;
        [self swap123:answers pos_1:i pos_2:j] ;
    }
    
//    for (int i = 0;i < NUMBER_OF_ANSWERS;i++) {
//        NSLog(@"%d:%d",i,answers[i]) ;
//    }
    
    StationContent *s ;
    s = [self.routeContent getStationContent:answers[0]] ;
    [self.answer1Button setTitle:[s getName_kanji] forState:UIControlStateNormal] ;
    s = [self.routeContent getStationContent:answers[1]] ;
    [self.answer2Button setTitle:[s getName_kanji] forState:UIControlStateNormal] ;
    s = [self.routeContent getStationContent:answers[2]] ;
    [self.answer3Button setTitle:[s getName_kanji] forState:UIControlStateNormal] ;
}

- (void)showLastView {
    StationContent *station = [self.routeContent getStationContent:self.currentPosition] ;
    
    self.navigationItem.title = [station getName_kanji] ;
    self.boardImage.image = [station getBoardImage ] ;
    
    self.currentPosition = 0;
    self.answer1Button.hidden = YES ;
    self.answer2Button.hidden = YES ;
    self.answer3Button.hidden = YES ;
    self.answer1Button.enabled = NO ;
    self.answer2Button.enabled = NO ;
    self.answer3Button.enabled = NO ;
    
    
    self.tryAgainButton.hidden = NO ;
    self.backButton.hidden = NO ;
    self.tryAgainButton.enabled= YES;
    self.backButton.enabled = YES ;
    self.commentText.text = @"到着〜!";
}

- (void)swap123:(int *)table pos_1:(int)a pos_2:(int)b {
    int tmp = table[a] ;
    table[a] = table[b] ;
    table[b] = tmp ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (IBAction)onAnswer1:(id)sender {
    [self onAnswer:answers[0]];
}

- (IBAction)onAnswer2:(id)sender {
    [self onAnswer:answers[1]];
}

- (IBAction)onAnswer3:(id)sender {
    [self onAnswer:answers[2]];
}

- (void)onAnswer:(int)answer {

    int nextPosition = self.currentPosition + 1 ;
    
    if (answer == nextPosition) {
        NSLog(@"Correct") ;
        self.currentPosition++ ;
        self.resultImage.image = [UIImage imageNamed:@"Image_correct"];
        [self.audioPlayer_correct play] ;
    } else {
        self.resultImage.image = [UIImage imageNamed:@"Image_wrong"];
        [self.audioPlayer_wrong play] ;
 
        NSLog(@"Incorrect") ;
    }
    self.resultImage.hidden = NO ;
    [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self
                                   selector:@selector(doSomethingWhenTimeIsUp:)
                                   userInfo:nil
                                    repeats:NO];
 
}

- (void) doSomethingWhenTimeIsUp:(NSTimer*)t {
    self.resultImage.hidden = YES ;

    int numberOfStations = [self.routeContent getNumberOfStations];
//    [self.audioPlayer_correct stop] ;
//    [self.audioPlayer_correct stop] ;

    if (self.currentPosition < numberOfStations - 1) {
        [self updateView];
    } else {
        [self showLastView];
    }
}
- (IBAction)onTryAgain:(id)sender {
    NSInteger count       = self.navigationController.viewControllers.count - 2;
    HomeViewController *vc = [self.navigationController.viewControllers objectAtIndex:count];
    [self.navigationController popToViewController:vc animated:YES];
}

- (IBAction)onBack:(id)sender {
    NSInteger count       = self.navigationController.viewControllers.count - 3;
    HomeViewController *vc = [self.navigationController.viewControllers objectAtIndex:count];
    [self.navigationController popToViewController:vc animated:YES];
}

@end
