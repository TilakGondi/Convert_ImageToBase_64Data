//
//  MainVC.m
//  imgBase64Data
//
//  Created by DEV_IPHONE_01 on 02/07/14.
//  Copyright (c) 2014 rossitek. All rights reserved.
//

#import "MainVC.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define SCREEN_WIDTH_LandScape ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT_LandScape ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};



@interface MainVC ()
{
    UIDeviceOrientation currentOrientation;
}
@end

@implementation MainVC
@synthesize popOverController,popOverPhotoSelector;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSString *)base64StringFromData:(NSData *)data length:(unsigned long)length
{
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result1;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result1 = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    while (true) {
        
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        for (i = 0; i < ctcopy; i++)
            [result1 appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result1 appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result1;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor lightTextColor]];
    
    btnPic=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnPic.tintColor=[UIColor greenColor];
    [btnPic setTitle:@"Select Picture From Gallery" forState:UIControlStateNormal];
    btnPic.frame=CGRectMake(10, 30, 230, 40);
    btnPic.layer.cornerRadius=10;
    btnPic.backgroundColor=[UIColor yellowColor];
    [btnPic setBackgroundColor:[UIColor yellowColor]];
    btnPic.layer.borderColor=[UIColor greenColor].CGColor;
    btnPic.layer.borderWidth=1.0f;
    [btnPic addTarget:self action:@selector(selectPictureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPic];
    
    base64DataTxt=[[UITextView alloc] initWithFrame:CGRectMake(10, 90,SCREEN_WIDTH-20 , SCREEN_HEIGHT-120)];
    
    UILabel *infoLbl=[[UILabel alloc] initWithFrame:CGRectMake(20, 70, 280, 20)];
    infoLbl.text=@"Selected Picture in Base-64 Format";
    infoLbl.textColor=[UIColor blueColor];
    infoLbl.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:infoLbl];
    
    base64DataTxt.layer.borderColor=[UIColor greenColor].CGColor;
    base64DataTxt.backgroundColor=[UIColor whiteColor];
    base64DataTxt.layer.borderWidth=1;
    base64DataTxt.editable=NO;
    [self.view addSubview:base64DataTxt];
   
}



-(void)selectPictureBtn
{
    
    base64DataTxt.text=@"";
    base64DataTxt.editable=NO;
    [self.popOverPhotoSelector dismissPopoverAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    base64DataTxt.editable=YES;
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    NSString *base64Str=[self base64StringFromData:imageData length:[imageData length]];
    base64DataTxt.text=base64Str;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}


#pragma mark - UITextView delegate methods

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return NO;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [base64DataTxt resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
