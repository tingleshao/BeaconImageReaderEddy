//
//  ViewController.m
//  BeaconImageReaderEddy
//
//  Created by Chong Shao on 12/29/15.
//  Copyright © 2015 Chong Shao. All rights reserved.
//

#import "ViewController.h"
#import "ESSBeaconScanner.h"
#include <stdlib.h>


@interface ViewController () <ESSBeaconScannerDelegate> {
    ESSBeaconScanner *_scanner;
}

@property (weak, nonatomic) IBOutlet UIImageView *theImage;
@property (weak, nonatomic) IBOutlet UITextView *theText;
@property (weak, nonatomic) IBOutlet UIButton *theButton;



@end

@implementation ViewController

@synthesize theURL;

NSString *url1;
NSString *url2;
NSString *url3;
NSMutableArray *case2Index;
float  map2[8][8];

- (void)viewDidLoad {
    
    url1 = @"";
    url2 = @"";
    url3 = @"";
    case2Index = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.theImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sprial2.png"]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _scanner = [[ESSBeaconScanner alloc] init];
    _scanner.delegate = self;
    [_scanner startScanning];
    [self.theText setText:theURL];
    
    float map[8][8];
    
    map[0][0] = 1;
    map[0][1] = 1;
    map[0][2] = 1;
    map[0][3] = 1;
    map[0][4] = 1;
    map[0][5] = 1;
    map[0][6] = 1;
    map[0][7] = 1;
    
    map[1][0] = 1;
    map[1][1] = 1;
    map[1][2] = 1;
    map[1][3] = 60;
    map[1][4] = 26;
    map[1][5] = 1;
    map[1][6] = 1;
    map[1][7] = 1;
    
    map[2][0] = 1;
    map[2][1] = 1;
    map[2][2] = 55;
    map[2][3] = 62;
    map[2][4] = 1;
    map[2][5] = 61;
    map[2][6] = 1;
    map[2][7] = 1;
    
    map[3][0] = 1;
    map[3][1] = 1;
    map[3][2] = 62;
    map[3][3] = 1;
    map[3][4] = 1;
    map[3][5] = 61;
    map[3][6] = 1;
    map[3][7] = 1;
    
    map[4][0] = 1;
    map[4][1] = 1;
    map[4][2] = 1;
    map[4][3] = 1;
    map[4][4] = 60;
    map[4][5] = 62;
    map[4][6] = 1;
    map[4][7] = 1;
    
    map[5][0] = 1;
    map[5][1] = 1;
    map[5][2] = 17;
    map[5][3] = 26;
    map[5][4] = 1;
    map[5][5] = 1;
    map[5][6] = 1;
    map[5][7] = 1;
    
    map[6][0] = 1;
    map[6][1] = 1;
    map[6][2] = 53;
    map[6][3] = 25;
    map[6][4] = 25;
    map[6][5] = 25;
    map[6][6] = 1;
    map[6][7] = 1;
    
    map[7][0] = 1;
    map[7][1] = 1;
    map[7][2] = 1;
    map[7][3] = 1;
    map[7][4] = 1;
    map[7][5] = 1;
    map[7][6] = 1;
    map[7][7] = 1;
    
//    float map2[8][8];
    NSMutableArray * index = [[NSMutableArray alloc]init];
    [index addObject:[NSNumber numberWithInt:19]];
    [index addObject:[NSNumber numberWithInt:34]];
 
  //  [index addObject:[NSNumber numberWithInt:22]];

  //  [index addObject:[NSNumber numberWithInt:13]];
    [self patchMap:map2 fromURLs:@"IãËIãËIãËIãË[Âfi¬àzºw´VÄÕªwz-©Õv×z¥ÃÎ-ÌPAÃËIãËIã#" withCase2Index:index];
    
    cv::Mat sprial = [self cvMatFromPatchMap: map2];
    UIImage *spiralImage = [self UIImageFromCVMat:sprial];
    
  //  [self.theImage setImage:spiralImage];
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(updateImage)
                                   userInfo:nil
                                    repeats:YES];

    
    NSLog(@"tried to load image");
}


- (void)updateImage {
    if (! [theURL isEqualToString:@""]) {
    [self patchMap:map2 fromURLs:[self theURL] withCase2Index:case2Index];
    
    cv::Mat sprial = [self cvMatFromPatchMap: map2];
    UIImage *spiralImage = [self UIImageFromCVMat:sprial];
    
    [self.theImage setImage:spiralImage];
    
    
  //  [self.theText setText:theURL];
    
    }
    else {
        CGSize size = CGSizeMake(self.theImage.frame.size.width, self.theImage.frame.size.height);
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        [[UIColor whiteColor] setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.theImage setImage:image];
    }
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_scanner stopScanning];
    _scanner = nil;
}


- (void)beaconScanner:(ESSBeaconScanner *)scanner
        didFindBeacon:(id)beaconInfo {
    NSLog(@"I Saw an Eddystone!: %@", beaconInfo);
}

- (void)beaconScanner:(ESSBeaconScanner *)scanner didUpdateBeacon:(id)beaconInfo {
    NSLog(@"I Updated an Eddystone!: %@", beaconInfo);
}


- (void)beaconScanner:(ESSBeaconScanner *)scanner didFindURL:(NSURL *)url {
    NSLog(@"I Saw an URL!: %@", url);
 //   NSMutableArray * index = [[NSMutableArray alloc]init];
  //  float map2[8][8];

    if ([[url absoluteString] characterAtIndex:7] == 'A') { // https
     //   url1 = [[url absoluteString] substringWithRange:NSMakeRange(8, [[url absoluteString] length]-8)];
 //       [self.theText setText:[NSString stringWithFormat:@"find one %@", [url absoluteString]]];
        self.theURL = @"IãËIãËIãá¹ãËIãöÖsËIêiÇªf5rfcrf5rf rf5rf/rf5rf5rf!";
        case2Index = [[NSMutableArray alloc]init];
        [case2Index addObject:[NSNumber numberWithInt:22]];
        
    }
    else if ([[url absoluteString] characterAtIndex:7] == 'D' || [[url absoluteString] characterAtIndex:7] == 'E') { // beacon 2
//        url2 = [[url absoluteString] substringWithRange:NSMakeRange(7, [[url absoluteString] length]-7)];
 //       [self.theText setText:[NSString stringWithFormat:@"find two %@", [url absoluteString]]];
        self.theURL = @"IãËIãËIíVIãËL©ÙiRf5rå6*f5rf5Zf5rf5Zf5rf5Zf5rf5rf!";
        case2Index = [[NSMutableArray alloc]init];
        [case2Index addObject:[NSNumber numberWithInt:13]];
        
         }
    else if ([[url absoluteString] characterAtIndex:7] == 'F') {// stop
        self.theURL = @"IãËIãËIãËIãË[Âfi¬àzºw´VÄÕªwz-©Õv×z¥ÃÎ-ÌPAÃËIãËIã#";
        case2Index = [[NSMutableArray alloc]init];
        [case2Index addObject:[NSNumber numberWithInt:19]];
        [case2Index addObject:[NSNumber numberWithInt:34]];
    }
    else if ([[url absoluteString] characterAtIndex:7] == 'C') {// up
        self.theURL = @"IãËIãËIãËIsËYÃâ{®F6¢qítÆ6¢qíÊf6¥áwIãË×óËIãËIãËIã#";
        case2Index = [[NSMutableArray alloc]init];
        [case2Index addObject:[NSNumber numberWithInt:16]];
        [case2Index addObject:[NSNumber numberWithInt:31]];
    }
    else if ([[url absoluteString] characterAtIndex:7] == 'B') {
        self.theURL = @"IãËIãËIãËIãËIãÆÀ®&5rd³¥@F5q³áeãËJcËIãËI³ËIãËIãËI+";
        case2Index = [[NSMutableArray alloc]init];
        [case2Index addObject:[NSNumber numberWithInt:16]];
        [case2Index addObject:[NSNumber numberWithInt:21]];
        [case2Index addObject:[NSNumber numberWithInt:22]];
        [case2Index addObject:[NSNumber numberWithInt:27]];
    }
    else {
        self.theURL = @"";
    }
    
 //   self.theURL = [url1 stringByAppendingString:url2];
 //   self.theURL = [theURL stringByAppendingString:url3];
    
    NSLog(@"the url: %@", self.theURL);
    //   [index addObject:[NSNumber numberWithInt:10]];
    //  [index addObject:[NSNumber numberWithInt:35]];
    
    
//    if ([self.theURL characterAtIndex:8] == 'V') {
//         [index addObject:[NSNumber numberWithInt:13]];
//    }
//    else {
//        [index addObject:[NSNumber numberWithInt:22]];
//    }
  }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(UIButton *)sender {
    [self patchMap:map2 fromURLs:[self theURL] withCase2Index:case2Index];
    
    cv::Mat sprial = [self cvMatFromPatchMap: map2];
    UIImage *spiralImage = [self UIImageFromCVMat:sprial];
    
    [self.theImage setImage:spiralImage];
    

    [self.theText setText:theURL];
    
    
    NSLog(@"Button Tapped!");
}

- (IBAction)testButtonTapped:(UIButton *)sender {
  //  NSString * url = @"IãËIãËIåö·¢f5·Æ>*f5rf¿bf5rq1rf5siÍQ£ËiKîøCËIãËIã#";
  //NSString * url = @"IãËIãËIãá¹ãËIãöÖsËIêiÇªf5rfcrf5rf rf5rf/rf5rf5rf!";
    NSString * url = @"IãËIãËIíVIãËL©ÙiRf5rå6*f5rf5Zf5rf5Zf5rf5Zf5rf5rf!";
    NSMutableArray * index = [[NSMutableArray alloc]init];
 //   [index addObject:[NSNumber numberWithInt:10]];
 //   [index addObject:[NSNumber numberWithInt:35]];
  
  //  [index addObject:[NSNumber numberWithInt:22]];
    [index addObject:[NSNumber numberWithInt:13]];
    NSString * binstr = [self binstrFromURL:url withCase2Index:index];
    
    NSLog(@"Bin str: %@ with length: %lu", binstr, [binstr length]);
    NSLog(@"Test Button Tapped!");
}


// opencv functions
- (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    NSLog(@"null:%s", (contextRef==NULL)? "true" : "false");
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIMatlabPngImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNone |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    NSLog(@"null:%s", (contextRef==NULL)? "true" : "false");
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                              //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


//  Decoding
- (void)patchMap:(float[8][8])map fromURLs:(NSString *)urls withCase2Index:(NSMutableArray *)index {
    // convert URLS into patch map
    // - convert URLS into binary
    // - split binary into decimal
//    const char *c = [urls UTF8String];
//    NSString *binStr = @"";
//    NSLog(@"here");
//    for (int i = 0; i < urls.length; i++) {
//        binStr = [binStr stringByAppendingString:[self binstrFromChar:c[i]]];
//    }
//    for (int i = 0; i < 64; i++) {
//        NSRange range = NSMakeRange(i*6, 6);
//        map[i/8][i%8] = (float)[self intFromBinStr:[binStr substringWithRange:range]];
//    }
//    return;
    
    NSString *binStr = [self binstrFromURL:urls withCase2Index:index];
    for (int i = 0; i < 64; i++) {
        NSRange range = NSMakeRange(i*6, 6);
        map[i/8][i%8] = (float)[self intFromBinStr:[binStr substringWithRange:range]];
    }
    return;
}


- (NSString *)binstrFromURL:(NSString *)url withCase2Index:(NSMutableArray *)index{
    
    NSDictionary *codeDict = @{ @33: @"00000000",
                                @34: @"00000001",
                                @35: @"00000010",
                                @36: @"00000011",
                                @37: @"00000100",
                                @38: @"00000101",
                                @39: @"00000110",
                                @40: @"00000111",
                                @41: @"00001000",
                                @42: @"00001001",
                                @43: @"00001010",
                                @44: @"00001011",
                                @45: @"00001100",
                                @46: @"00001101",
                                @47: @"00001110",
                                @48: @"00001111",
                                @49: @"00010000",
                                @50: @"00010001",
                                @51: @"00010010",
                                @52: @"00010011",
                                @53: @"00010100",
                                @54: @"00010101",
                                @55: @"00010110",
                                @56: @"00010111",
                                @57: @"00011000",
                                @58: @"00011001",
                                @59: @"00011010",
                                @60: @"00011011",
                                @61: @"00011100",
                                @62: @"00011101",
                                @63: @"00011110",
                                @64: @"00011111",
                                @65: @"00100000",
                                @66: @"00100001",
                                @67: @"00100010",
                                @68: @"00100011",
                                @69: @"00100100",
                                @70: @"00100101",
                                @71: @"00100110",
                                @72: @"00100111",
                                @73: @"00101000",
                                @74: @"00101001",
                                @75: @"00101010",
                                @76: @"00101011",
                                @77: @"00101100",
                                @78: @"00101101",
                                @79: @"00101110",
                                @80: @"00101111",
                                @81: @"00110000",
                                @82: @"00110001",
                                @83: @"00110010",
                                @84: @"00110011",
                                @85: @"00110100",
                                @86: @"00110101",
                                @87: @"00110110",
                                @88: @"00110111",
                                @89: @"00111000",
                                @90: @"00111001",
                                @91: @"00111010",
                                @92: @"00111011",
                                @93: @"00111100",
                                @94: @"00111101",
                                @95: @"00111110",
                                @96: @"00111111",
                                @97: @"01000000",
                                @98: @"01000001",
                                @99: @"01000010",
                                @100: @"01000011",
                                @101: @"01000100",
                                @102: @"01000101",
                                @103: @"01000110",
                                @104: @"01000111",
                                @105: @"01001000",
                                @106: @"01001001",
                                @107: @"01001010",
                                @108: @"01001011",
                                @109: @"01001100",
                                @110: @"01001101",
                                @111: @"01001110",
                                @112: @"01001111",
                                @113: @"01010000",
                                @114: @"01010001",
                                @115: @"01010010",
                                @116: @"01010011",
                                @117: @"01010100",
                                @118: @"01010101",
                                @119: @"01010110",
                                @120: @"01010111",
                                @121: @"01011000",
                                @122: @"01011001",
                                @123: @"01011010",
                                @124: @"01011011",
                                @125: @"01011100",
                                @126: @"01011101",
                                @32:  @"01011110",
                                @160: @"01011111",
                                @161: @"01100000",
                                @162: @"01100001",
                                @163: @"01100010",
                                @164: @"01100011",
                                @165: @"01100100",
                                @166: @"01100101",
                                @167: @"01100110",
                                @168: @"01100111",
                                @169: @"01101000",
                                @170: @"01101001",
                                @171: @"01101010",
                                @172: @"01101011",
                                @173: @"01101100",
                                @174: @"01101101",
                                @175: @"01101110",
                                @176: @"01101111",
                                @177: @"01110000",
                                @178: @"01110001",
                                @179: @"01110010",
                                @180: @"01110011",
                                @181: @"01110100",
                                @182: @"01110101",
                                @183: @"01110110",
                                @184: @"01110111",
                                @185: @"01111000",
                                @186: @"01111001",
                                @187: @"01111010",
                                @188: @"01111011",
                                @189: @"01111100",
                                @190: @"01111101",
                                @191: @"01111110",
                                @192: @"01111111",
                                @193: @"10000000",
                                @194: @"10000001",
                                @195: @"10000010",
                                @196: @"10000011",
                                @197: @"10000100",
                                @198: @"10000101",
                                @199: @"10000110",
                                @200: @"10000111",
                                @201: @"10001000",
                                @202: @"10001001",
                                @203: @"10001010",
                                @204: @"10001011",
                                @205: @"10001100",
                                @206: @"10001101",
                                @207: @"10001110",
                                @208: @"10001111",
                                @209: @"10010000",
                                @210: @"10010001",
                                @211: @"10010010",
                                @212: @"10010011",
                                @213: @"10010100",
                                @214: @"10010101",
                                @215: @"10010110",
                                @216: @"10010111",
                                @217: @"10011000",
                                @218: @"10011001",
                                @219: @"10011010",
                                @220: @"10011011",
                                @221: @"10011100",
                                @222: @"10011101",
                                @223: @"10011110",
                                @224: @"10011111",
                                @225: @"10100000",
                                @226: @"10100001",
                                @227: @"10100010",
                                @228: @"10100011",
                                @229: @"10100100",
                                @230: @"10100101",
                                @231: @"10100110",
                                @232: @"10100111",
                                @233: @"10101000",
                                @234: @"10101001",
                                @235: @"10101010",
                                @236: @"10101011",
                                @237: @"10101100",
                                @238: @"10101101",
                                @239: @"10101110",
                                @240: @"10101111",
                                @241: @"10110000",
                                @242: @"10110001",
                                @243: @"10110010",
                                @244: @"10110011",
                                @245: @"10110100",
                                @246: @"10110101",
                                @247: @"10110110",
                                @248: @"10110111",
                                @249: @"10111000",
                                @250: @"10111001",
                                @251: @"10111010",
                                @252: @"10111011"
                                };
    NSString * binstr = @"";
    int k = 0;
 //   const char *c = [url UTF8String];
    NSLog(@"hi");
    for (int i = 0; i < [url length]-1; i++) {
        char c = [url characterAtIndex:i];
        if (k < [index count] && [(NSNumber *)[index objectAtIndex:k] integerValue] == i) {
            NSLog(@"case 2 c[i]: %c %i", c, [[NSNumber numberWithChar:c] unsignedCharValue]);
            NSLog(@"case 2last binary: %@ ",[codeDict objectForKey:[NSNumber numberWithInt:[[NSNumber numberWithChar:c] unsignedCharValue]]]);

             binstr = [binstr stringByAppendingString:[[codeDict objectForKey:[NSNumber numberWithInt:[[NSNumber numberWithChar:c] unsignedCharValue]]] substringWithRange:NSMakeRange(1, 7)]];
            k+=1;
        }
        else {
        NSLog(@"c[i]: %c %i", c, [[NSNumber numberWithChar:c] unsignedCharValue]);
            binstr = [binstr stringByAppendingString:[codeDict objectForKey:[NSNumber numberWithInt:[[NSNumber numberWithChar:c] unsignedCharValue]]]];
        }
    }
    char c = [url characterAtIndex:[url length]-1];
     NSLog(@"last binary: %@ %lu %lu",[codeDict objectForKey:[NSNumber numberWithInt:[[NSNumber numberWithChar:c] unsignedCharValue]]], 8-[index count],[index count]);
    
    binstr = [binstr stringByAppendingString:[[codeDict objectForKey:[NSNumber numberWithInt:[[NSNumber numberWithChar:c] unsignedCharValue]]] substringWithRange:NSMakeRange(8-[index count],[index count])]];
   
    return binstr;
}



- (int)intFromBinStr:(NSString *)binStr {
    const char* utf8String = [binStr UTF8String];
    char* endPtr = NULL;
    long int foo = strtol(utf8String, &endPtr, 2);
    return (int)foo;
}


- (NSString *)binstrFromChar:(char) c {
    NSString *binstr = @"";
    NSMutableString *mutableBinstr = [binstr mutableCopy];
    int theNumber = int(c);
    for (NSInteger numberCopy = theNumber; numberCopy > 0; numberCopy >>= 1) {
        // Prepend "0" or "1", depending on the bit
        [mutableBinstr insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
    }
    for (int i = 0; i < mutableBinstr.length - 8; i++) {
         [mutableBinstr insertString:@"0" atIndex:0];
    }
    return [NSString stringWithString:mutableBinstr];
}


- (cv::Mat)cvMatFromPatchMap:(float[8][8]) map {
    //   cv::Mat cvMat;
    CGFloat rows = 64;
    CGFloat cols = 64;
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    cvMat.at<char>(0,0) = 255;
    cvMat.at<char>(0,1) = 255;
    cvMat.at<char>(1,0) = 255;
    cvMat.at<char>(1,1) = 255;

    for (int j = 0; j < 8; j++) {
        for (int i = 0; i < 8; i++) {
            cv::Mat patch = [self cvMatGrayFromUIMatlabPngImage:
                             [UIImage imageNamed:[NSString stringWithFormat:@"new_fig_bin_kmeans_filter%d.png", (int)map[i][j]]]];
            for (int y = 0; y < 8; y++) {
                for (int x = 0; x < 8; x++) {
                    cvMat.at<char>(i*8+x, j*8+y) =  patch.at<char>(x,y);
                }
            }
        }
    }
    return cvMat;
}

@end
