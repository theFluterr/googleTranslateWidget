//
//  TodayViewController.m
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "TodayViewController.h"
#import "GoogleRequest.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

@synthesize dictController;
@synthesize langList;



- (void)didFinishLoadingStuff:(NSData *)stuff {
    NSString *strData = [[NSString alloc]initWithData:stuff encoding:NSUTF8StringEncoding];
    int startNewWord = 4,endNewWord=0;
    for(int i=4;i<[strData length];i++) {
        if([[strData substringWithRange:NSMakeRange(i,1)] isEqual:@"\""]) {
            endNewWord=i;
            break;
        }
    }
    NSString *newWord=[strData substringWithRange:NSMakeRange(startNewWord, endNewWord-startNewWord)];
    [_outputText setStringValue:newWord];
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);
    
}
-(IBAction)swapButton: (id)sender {
    GoogleRequest *newRequest=[[GoogleRequest alloc] init];
    [newRequest sendRequestWithSourceLanguage:[[self createList]valueForKey:[_sourceLanguagePopUp titleOfSelectedItem]] TargetLanguage:[[self createList]valueForKey:[_targetLanguagePopUp titleOfSelectedItem]] Text:[_inputText stringValue] Sender:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_sourceLanguageMenu setAutoenablesItems:NO];
    for(int a=0;a<[[[self createList] allKeys] count];a++) {
        NSMenuItem *item=[ _sourceLanguageMenu addItemWithTitle:[[[self createList]allKeys]objectAtIndex:(NSUInteger)a ] action:@selector(sourceTabClick:) keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    

    [ _targetLanguagePopUp addItemsWithTitles:[[self createList] allKeys]];
    [_sourceSegmentedButton setMenu:_sourceLanguageMenu forSegment:(NSInteger)3];

}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    NSLog(@"controlTextDidChange: stringValue == %@", [textField stringValue]);
    GoogleRequest *newRequest=[[GoogleRequest alloc] init];
    [newRequest sendRequestWithSourceLanguage:[[self createList]valueForKey:[_sourceLanguagePopUp titleOfSelectedItem]] TargetLanguage:[[self createList]valueForKey:[_targetLanguagePopUp titleOfSelectedItem]] Text:[_inputText stringValue] Sender:self];
    
}

//- (id)init {
//    if (!(self = [super init]))
//        return nil;
//
//    languageList *newList=[[languageList alloc] init];
//    [newList createList];
//    [dictController addObject:[languageList.langList];
//
//    return self;
//}

-(NSDictionary*) createList {
    
    NSArray *keys = @[@"English", @"Russian", @"Finnish"];
    NSArray *values = @[@"en", @"ru", @"fi"];
    
    langList = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    return langList;
}


- (void)sourceTabClick:(id)sender {
    [_sourceSegmentedButton pushNewChosenLanguage:[sender title]];
}
@end







