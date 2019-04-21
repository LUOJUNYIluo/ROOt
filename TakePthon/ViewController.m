//
//  ViewController.m
//  TakePthon
//
//  Created by 天使 on 21/04/2019.
//  Copyright © 2019 天使. All rights reserved.

//s哒哒哒哒哒
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ViewImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建对象
    ALAssetsLibrary *asset = [[ALAssetsLibrary alloc] init];
    //创建队列
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //开启异步线程
    dispatch_async(q, ^{
        NSLog(@"%@",[NSThread currentThread]);
        //扫描我们的媒体库
        [asset enumerateGroupsWithTypes:(ALAssetsGroupAll) usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                NSString *asseType = [result valueForProperty:ALAssetPropertyType];
                //判断是不是图片
                if ([asseType isEqualToString:ALAssetTypePhoto]) {
                    *stop = false;
                  ALAssetRepresentation *assetRepresentation = [result defaultRepresentation];
                    //缩放参数
                  CGFloat imagescale =  [assetRepresentation scale];
                    UIImageOrientation  ImageOrientation  = (UIImageOrientation *)[assetRepresentation orientation];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CGImageRef ImageRef = [assetRepresentation fullResolutionImage];
                        UIImage *img = [[UIImage alloc] initWithCGImage:ImageRef scale:imagescale orientation:ImageOrientation];
                        if (img  != nil) {
                            self.ViewImage.image = img;
                        }
                    });
                }
            }];
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    });
    
}


@end
