//
//  GoogleRequest.m
//  
//
//  Created by Mark Vasiv on 27/08/15.
//
//

#import "GoogleRequest.h"

@implementation GoogleRequest
-(NSString*) sendRequestWithSourceLanguage:(NSString *)sLanguage TargetLanguage:(NSString *)tLanguage Text:(NSString *)inputText {
    
    
    
    
    
    NSString *escapedInput = [inputText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@%@%@%@",@"https://translate.googleapis.com/translate_a/single?client=gtx&ie=UTF-8&oe=UTF-8&sl=",sLanguage,@"&tl=",tLanguage,@"&dt=t&q=",escapedInput];

   
    
    NSURL *url=[NSURL URLWithString:urlString];
    
    NSError *err;
    NSURLResponse *response;
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod :@"POST"];
    
    NSData *receivedData = [NSMutableData dataWithCapacity: 0];
    receivedData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    if (receivedData == nil)
    {
        if (err != nil)
        {
            NSLog(@"Error description=%@", [err description]);
        }
    }
    
    
    NSString *strData = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
   
    int startNewWord = 4,endNewWord=0;
    for(int i=4;i<[strData length];i++) {
        if([[strData substringWithRange:NSMakeRange(i,1)] isEqual:@"\""]) {
            endNewWord=i;
            break;
        }
    }
    
    NSString *newWord=[strData substringWithRange:NSMakeRange(startNewWord, endNewWord-startNewWord)];
    
    return newWord;
}
@end