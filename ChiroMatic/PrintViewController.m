//
//  PrintViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/20/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "PrintViewController.h"
#import "PrintContentViewController.h"
#import <CoreText/CoreText.h>
static const float FINDINGS_SPACING_CONSTANT = 16.0f;
static const float FINDINGS_LABEL_WIDTH = 470.0f;

@interface PrintViewController ()

@property (strong,nonatomic) NSString* footerText;
@property (strong,nonatomic) MFMailComposeViewController * controller;

@end

@implementation PrintViewController

-(NSSet*) passedData
{
    return self.printedObjects;
}

- (IBAction)print:(UIButton*)sender {
    UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
    UIPrintInfo* printInfo = [UIPrintInfo printInfo];
    printInfo.jobName = @"ChiroMatic Report";
    printInfo.outputType = UIPrintInfoOutputGeneral;
    //printController.printPageRenderer = [self renderPage];
    
    printController.printingItem = [self renderScrollViewToImage];
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
        }
    };
    [printController presentFromRect:sender.frame inView:self.view animated:YES completionHandler:completionHandler];
    
    
}

- (ReportPageRenderer*) renderPage
{
    ReportPageRenderer* renderer = [[ReportPageRenderer alloc] init];
    renderer.footerText = self.footerText;
    UIImageView* imageview = [[UIImageView alloc]initWithImage:[self renderScrollViewToImage]];
    UIPrintFormatter* formatter = [imageview viewPrintFormatter];
    [renderer addPrintFormatter:formatter startingAtPageAtIndex:0];
    
    return renderer;
}

-(void)drawPDF:(NSString*)fileName
{
    NSString* localDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    [self drawLabels];
    
    // Close the PDF context and write out the contents.
    UIGraphicsEndPDFContext();
    
    NSURL* url = [NSURL fileURLWithPath:fileName];
    
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL ((__bridge CFURLRef) url);
    
    UIGraphicsBeginImageContext(CGSizeMake(596,842));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(currentContext, 0, 842);
    CGContextScaleCTM(currentContext, 1.0, -1.0); // make sure the page is the right way up
    
    CGPDFPageRef page = CGPDFDocumentGetPage (document, 1); // first page of PDF is page 1 (not zero)
    CGContextDrawPDFPage (currentContext, page);  // draws the page in the graphics context
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm-dd-yyyy hh:mm"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    NSString* imagePathComponent = [NSString stringWithFormat:@"ChiroMatic Report %@.png",dateString];
    NSString* imagePath = [localDocuments stringByAppendingPathComponent: imagePathComponent];
    [UIImagePNGRepresentation(image) writeToFile: imagePath atomically:YES];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); // do error checking in production code
}

-(void)drawImage:(UIImage*)image inRect:(CGRect)rect
{
    
    [image drawInRect:rect];
    
}

-(void)drawLabels
{
    for (UIView* view in [self.scrollView subviews]) {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
            if (label.text)
                [self drawText:label.text inFrame:label.frame];
        }
    }
}

-(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect
{
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    
    // Add these two lines to reverse the earlier transformation.
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}

- (IBAction)pdf:(id)sender {
    UIImage* image = [self renderScrollViewToImage];
    ChiroMaticAppDelegate* delegate = [[UIApplication sharedApplication]delegate];
    delegate.imageToBeSaved = image;
    [delegate saveImageToDisk];
    
    //Create a nice little popup telling user to check photos section
    
    
    /*NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm-dd-yyyy hh:mm"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    NSString* fileName = [NSString stringWithFormat:@"ChiroMatic Report %@.PDF",dateString];
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    [self drawPDF:pdfFileName];*/
    
}

- (IBAction)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        UIImage* image = [self renderScrollViewToImage];
        NSData* data = UIImagePNGRepresentation(image);
        self.controller = [[MFMailComposeViewController alloc]init];
        [self.controller setSubject:@"Make it Brief Report"];
        [self.controller addAttachmentData:data mimeType:@"image/png" fileName:@"MiB Report"];
        self.controller.mailComposeDelegate = self;
        [self presentViewController:self.controller animated:YES completion:^{
            NSLog(@"Email form presented");
        }];
    } else {
        NSLog(@"Cannot email from this device");
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



- (UIImage*) renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, YES, 0.0);
    {
        CGPoint savedContentOffset = self.scrollView.contentOffset;
        CGRect savedFrame = self.scrollView.frame;
        
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
        
        [self.scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _scrollView.contentOffset = savedContentOffset;
        _scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}

# pragma mark ScrollView Setup Methods

-(void) viewDidAppear:(BOOL)animated
{
    //--Set the header image
    if (self.report.patient.doctor.clinic.logo) {
        UIImage* image = [UIImage imageWithData:self.report.patient.doctor.clinic.logo];
        self.clinicLogoLabel.image = image;
        self.clinicLogoLabel.contentMode = UIViewContentModeScaleAspectFit;
    }else
    {
        UILabel* clinicTitleHeaderLabel = [[UILabel alloc]initWithFrame:self.clinicLogoLabel.frame];
        clinicTitleHeaderLabel.textAlignment = NSTextAlignmentCenter;
        clinicTitleHeaderLabel.text = self.report.clinic.name;
        clinicTitleHeaderLabel.font = [UIFont systemFontOfSize:16];
        [self.scrollView addSubview:clinicTitleHeaderLabel];
    }
    //--Create the labels
    for (UILabel* label in self.scrollView.subviews) {
        [label setHidden:NO];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [NSDate date];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    self.dateLabel.text = formattedDateString;
    self.insuranceNameLabel.text = self.report.insuranceBilled.name;
    NSString* suiteNumberString;
    if (self.report.insuranceBilled.suiteNumber)
        suiteNumberString = [NSString stringWithFormat:@"#%@",self.report.insuranceBilled.suiteNumber];
    else
        suiteNumberString = @"";
    
    NSString* insuranceAddressString = [NSString stringWithFormat:@"%@ %@",self.report.insuranceBilled.address,suiteNumberString];
    self.insuranceAddress.text = insuranceAddressString;
    NSString* cityStateString = [NSString stringWithFormat:@"%@, %@",self.report.insuranceBilled.city,self.report.insuranceBilled.state];
    self.cityStateLabel.text = cityStateString;
    self.suiteLabel.text = self.report.insuranceBilled.suiteNumber;
    
    if (self.report.insuranceBilled.contact) 
        self.insuranceContactLabel.text = [NSString stringWithFormat:@"Dear %@:",self.report.insuranceBilled.contact];
    else self.insuranceContactLabel.text = [NSString stringWithFormat:@"Dear %@:",self.report.insuranceBilled.name];
    self.repatientNameLabel.text = [NSString stringWithFormat:@"RE: %@",self.report.patient.name];
    self.policyNumberLabel.text = self.report.patient.policyNumber;
    self.examNameLabel.text = self.report.name;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm-dd-yyyy"];
    NSString* formattedReportDateString;
    formattedReportDateString = [formatter stringFromDate:self.report.date];
    self.openingSentenceLabel.text = [NSString stringWithFormat:@"On %@, %@ was performed on %@.\nBelow are the findings:",formattedReportDateString,self.report.name,self.report.patient.name];
    
    //--Generate Findings content
    NSMutableArray* findings = [NSMutableArray arrayWithCapacity:0];
    for (Exam* exam in self.report.exams)
    {
        [findings addObject:exam];
    }
    
    CGRect footerRect = CGRectMake(20.0f, self.footerLabel.frame.origin.y - 50.0f, 100.0f, 30.0f);
    
    //----Setup Signature Image/Text
    /*if (self.report.patient.doctor.signature) {
        CGRect signatureRect = CGRectMake(200.0f, self.footerLabel.frame.origin.y - 65.0f, 278.0f, 88.0f);
        CGRect signoffRect = CGRectMake(200.0f, signatureRect.origin.y - 30, 278.0f, 30.0f);
        UIImage* image = [UIImage imageWithData:self.report.patient.doctor.signature];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:signatureRect];
        imageView.image = image;
        
        UILabel* label = [[UILabel alloc]initWithFrame:signoffRect];
        label.text = @"Sincerely,";
        
        [self.scrollView addSubview:label];
        [self.scrollView addSubview:imageView];
        
    }else
    {*/
    CGRect signatureRect = CGRectMake(50.0f, 640.0f, 100.0f,40.0f);
    UILabel* label = [[UILabel alloc] initWithFrame:signatureRect];
    [label setNumberOfLines:2];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    label.text = [NSString stringWithFormat:@"Sincerely,\n%@",self.report.patient.doctor.name];
    NSLog(@"Signoff: %@",label.text);
    [self.scrollView addSubview:label];
    /*}*/
    NSMutableArray* findingsLabelArray = [NSMutableArray arrayWithCapacity:[findings count]];
    CGRect newFooterRect;
    double startheight = self.openingSentenceLabel.frame.origin.y + 40;
    CGRect findingsFrame = CGRectMake(75.0f, startheight + (FINDINGS_SPACING_CONSTANT), FINDINGS_LABEL_WIDTH, FINDINGS_SPACING_CONSTANT);
    //int findingsCounterHelper;
    for (int i = 0; i < [findings count]; i++)
    {
        Exam* exam = [findings objectAtIndex:i];
        
        UILabel* findingsLabel = [[UILabel alloc]initWithFrame:findingsFrame];
        //findingsLabel.numberOfLines = 1;
        //findingsLabel.adjustsFontSizeToFitWidth = YES;
        findingsLabel.adjustsLetterSpacingToFitWidth = YES;
        findingsLabel.text = [NSString stringWithFormat:@"%@:\t\t\t\t%@",exam.name,exam.result];
        findingsLabel.font = [UIFont systemFontOfSize:11];
        //[self.scrollView addSubview:findingsLabel];
        newFooterRect = CGRectMake(footerRect.origin.x, footerRect.origin.y+(FINDINGS_SPACING_CONSTANT*(i+1)), footerRect.size.width, footerRect.size.height);
        
        [findingsLabelArray addObject:findingsLabel];
        if (findingsLabel.text.length >= 100) {
            findingsLabel.frame = CGRectMake(findingsLabel.frame.origin.x, findingsLabel.frame.origin.y, findingsLabel.frame.size.width, findingsLabel.frame.size.height *2);
            findingsLabel.numberOfLines = 2;
            CGRect newFrame = CGRectMake(75.0f, (findingsFrame.origin.y + FINDINGS_SPACING_CONSTANT), FINDINGS_LABEL_WIDTH, FINDINGS_SPACING_CONSTANT-2.5);
            findingsFrame = newFrame;
        }
        CGRect newFrame = CGRectMake(75.0f, (findingsFrame.origin.y + FINDINGS_SPACING_CONSTANT), FINDINGS_LABEL_WIDTH, FINDINGS_SPACING_CONSTANT-2.5);
        findingsFrame = newFrame;
    }
    
    //Generate the Action and Prognosis portions of the report
    CGRect actionFrame;
    if (self.report.action) {
        actionFrame = CGRectMake(30.0f, findingsFrame.origin.y+FINDINGS_SPACING_CONSTANT, 550, 60);
        UILabel* actionLabel = [[UILabel alloc] initWithFrame:actionFrame];
        actionLabel.numberOfLines = 3;
        actionLabel.adjustsLetterSpacingToFitWidth = YES;
        actionLabel.text = self.report.action;
        actionLabel.font = [UIFont systemFontOfSize:12];
        [self.scrollView addSubview:actionLabel];
    }else
        actionFrame = CGRectMake(30.0f, findingsFrame.origin.y-FINDINGS_SPACING_CONSTANT, 550, 60);
    if (self.report.prognosis) {
        CGRect prognosisFrame = CGRectMake(30.0f, actionFrame.origin.y+60, 550, 60);
        UILabel* prognosisLabel = [[UILabel alloc] initWithFrame:prognosisFrame];
        prognosisLabel.numberOfLines = 3;
        prognosisLabel.adjustsLetterSpacingToFitWidth = YES;
        prognosisLabel.text = self.report.prognosis;
        prognosisLabel.font = [UIFont systemFontOfSize:12];
        [self.scrollView addSubview:prognosisLabel];
    }
    /*--Generate Footer Content
    Clinic* clinic = self.report.patient.doctor.clinic;
    UILabel* footerLabel = [[UILabel alloc]initWithFrame:footerRect];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.text = [NSString stringWithFormat:@"%@ • %@ • %@",clinic.name,clinic.address,clinic.website];*/
    
    Clinic* clinic = self.report.patient.doctor.clinic;
    self.footerText = [NSString stringWithFormat:@"%@\n%@\n%@ • %@",clinic.name,clinic.address,clinic.phone,clinic.website];
    self.footerLabel.text = self.footerText;
    
    //--Setup the Scrollview
    NSLog(@"%@",self.scrollView);
    //CGSize newScrollviewSize = CGSizeMake(self.scrollView.frame.size.width, footerRect.origin.y + 30.0f);
    CGSize newScrollViewSize = CGSizeMake(612, 792);
    [self.scrollView setContentSize:newScrollViewSize];
    NSLog(@"Scrollview Contentsize: %f,%f",self.scrollView.frame.size.width,self.scrollView.frame.size.height);
    //--Add created views
    //[self.scrollView addSubview:footerLabel];
    for (UILabel* findingsLabel in findingsLabelArray) {
        [self.scrollView addSubview:findingsLabel];
    }
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setOpaque:YES];
}
@end
