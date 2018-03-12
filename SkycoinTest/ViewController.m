//
//  ViewController.m
//  SkycoinTest
//
//  Created by PanYibin on 2018/3/3.
//  Copyright © 2018年 PanYibin. All rights reserved.
//

#import "ViewController.h"
#import <Mobile/Mobile.h>

//skycoin_dea0b60df205dc4e9bdc720e
#define kWalletId @"kWalletId"
#define kCoinTypeSkyCoin @"skycoin"

@interface ViewController ()
{
    NSString *currentWallet;
    NSString *password;
}

@property (nonatomic, strong) IBOutlet UILabel *balance;
@property (nonatomic, strong) IBOutlet UILabel *skyHours;

@property (nonatomic, strong) IBOutlet UITextField *recipientAddress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *walletDir = [self getWalletDir];
    NSString *pinCode = @"123456";
    password = [NSString stringWithFormat:@"%lu", pinCode.hash];
    
    NSError *error;
    MobileInit(walletDir, password, &error);
    if(!error) {
        NSLog(@"init successfully");
    } else {
        NSLog(@"init failed");
    }
    
    MobileRegisterNewCoin(@"spocoin", @"47.75.36.182:8620", &error);
    MobileRegisterNewCoin(@"skycoin", @"47.75.36.182:6420", &error);
    if(!error) {
        NSLog(@"RegisterNewCoin successfully");
    } else {
        NSLog(@"RegisterNewCoin failed");
    }
    
    [self loadWallet];
    
    [self refreshBalance];
}

- (void)refreshBalance {
    NSError *error;
    NSString *balanceStr = MobileGetBalance(@"skycoin", @"iUedjjMkr5DzceutJWHaGaP6RTR6mPcVbj", &error);
    NSDictionary *balanceDict = [self dictionaryOfJsonString:balanceStr];
    
    NSString *balance = [balanceDict objectForKey:@"balance"];
    NSString *hours = [balanceDict objectForKey:@"hours"];
    
    self.balance.text = [NSString stringWithFormat:@"balance:%@", balance ? : @"null"];
    self.skyHours.text = [NSString stringWithFormat:@"hours:%@", hours ? : @"null"];
}

- (NSDictionary*)dictionaryOfJsonString:(NSString*)jsonStr {
    NSDictionary *dict;
    NSError *error;
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if(!error) {
        return dict;
    } else {
        return nil;
    }
}

- (IBAction)clickRefresh:(id)sender {
    [self refreshBalance];
}

- (IBAction)clickSendCoin:(id)sender {
    [self sendCoin:0.001 toAddress:self.recipientAddress.text];
}

- (BOOL)sendCoin:(float)amount toAddress:(NSString*)recipientAddress {
    NSError *error;
    NSString *amountStr = [NSString stringWithFormat:@"%f", amount];
    MobileSend(kCoinTypeSkyCoin, currentWallet, recipientAddress, amountStr, &error);
    if(!error) {
        NSLog(@"send coin successfully");
    } else {
        NSLog(@"failed to send coins with error:%@", error);
    }
    
    return YES;
}

- (void)loadWallet {
    NSString *existedWalletId = [[NSUserDefaults standardUserDefaults] objectForKey:kWalletId];//@"skycoin_myWallet";
    NSString * seed = @"exclude budget wrap patch width garbage game hand shaft sock tag scheme";
    NSError *error;
    if(!existedWalletId && !MobileIsExist(existedWalletId)) {
        NSLog(@"create new wallet");
        currentWallet = MobileNewWallet(@"skycoin", @"myWallet", seed, password, &error);
        if(currentWallet) {
            [[NSUserDefaults standardUserDefaults] setObject:currentWallet forKey:kWalletId];
        }
    } else {
        NSLog(@"wallet existed,wallet id:%@", existedWalletId);
        BOOL success = MobileLoadWallet(password, &error);
        if(success) {
            NSLog(@"load wallet succeeded");
        } else {
            NSLog(@"load wallet failed");
        }
        
        currentWallet = existedWalletId;
    }
    
    NSLog(@"wallet seeds:%@", MobileGetSeed(currentWallet, &error));
    
    NSLog(@"wallet id:%@", currentWallet);
    
    NSLog(@"addresses:%@", MobileGetAddresses(currentWallet, &error));
}

- (NSURL*)applicationDocumentDirUrl {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString*)getWalletDir {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyFolder"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    return dataPath;
}

@end
