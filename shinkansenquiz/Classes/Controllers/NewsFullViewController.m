//
//  NewsFullViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/12.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "NewsFullViewController.h"
#import "NewsFullCell.h"

@interface NewsFullViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CGFloat rowHeight ;

@end


@implementation NewsFullViewController
@synthesize newsTitle = _newsTitle ;
@synthesize newsContents = _newsContents ;
@synthesize newsImage = _newsImage;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Setting up listview
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;
    
    UINib *nib = [UINib nibWithNibName:NewsFullCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"NewsFullCell"];
    
    self.rowHeight = 600.0f ;
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsFullCell";
    NewsFullCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.newsTitle.text = self.newsTitle ;
    cell.newsContents.text = self.newsContents ;
    cell.newsImage.image = self.newsImage ;
    
    [cell.newsContents sizeToFit] ;
    [cell.newsImage sizeToFit] ;
    
    self.rowHeight = cell.newsContents.frame.size.height +
                     cell.newsImage.frame.size.height + 100.0f ;
     
    return cell;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
