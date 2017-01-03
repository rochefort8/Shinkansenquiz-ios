//
//  QuizStartViewController.m
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/12/25.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import "QuizStartViewController.h"
#import "QuizStationViewController.h"

@import GoogleMobileAds;

@interface QuizStartViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *route;
@property (weak, nonatomic) IBOutlet UIImageView *map;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *signalImage;

@property(nonatomic) AVAudioPlayer *audioPlayer ;

@end

@implementation QuizStartViewController
@synthesize routeContent = _routeContent ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    self.navigationItem.title = self.routeName_jp ;
    NSString *section = [NSString stringWithFormat:@"%@ ~ %@",
                         self.startingStation,self.terminusStation];
    self.route.text = section ;
    */
    self.navigationItem.title = [self.routeContent getName_jp] ;
    NSString *section = [NSString stringWithFormat:@"%@ ~ %@",
                         [self.routeContent getStartingStation],
                         [self.routeContent getTerminusStation]];
    self.route.text = section ;
    
    // AdMob
    // Replace this ad unit ID with your own ad unit ID.
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify.Your test device ID is printed to the
    // console when an ad request is made. GADBannerView automatically
    // returns test ads when running on a simulator.
    //    request.testDevices = @[
    //                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
    //                            ];
    [self.bannerView loadRequest:request];
    
    [self initAudio] ;
    
    /*
     For remove warning,
     "Capturing self strongly in this block is likely to lead to a retain cycle"
     */
//    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.routeContent loadData:^(NSError *error) {
        if (!error){
//            [weakSelf.activityIndicator stopAnimating ];
//            [weakSelf.startButton setEnabled:YES] ;
        } else {
//            [self.activityIndicator stopAnimating ];
//            [self.startButton setEnabled:YES] ;
        }
    }];
    
}
- (void)initAudio
{
    NSError *error ;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tokaido_tokyo_bell" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = 0 ;
    if ( error != nil ) {
        NSLog(@"Error %@", [error localizedDescription]);
    }
    [self.audioPlayer setDelegate:self];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    QuizStationViewController *secondViewController = segue.destinationViewController ;
    secondViewController.routeContent = self.routeContent ;
}

- (IBAction)onStart:(id)sender {
    [_audioPlayer play] ;
    self.signalImage.image = [UIImage imageNamed:@"Image_Signal_Yellow"];
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(doSomethingWhenTimeIsUp:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) doSomethingWhenTimeIsUp:(NSTimer*)t {
    self.signalImage.image = [UIImage imageNamed:@"Image_Signal_Green"];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self performSegueWithIdentifier:@"toQuizView" sender:self];
}

@end
