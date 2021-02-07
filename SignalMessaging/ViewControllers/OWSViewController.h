//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSViewController : UIViewController

@property (nonatomic) BOOL shouldIgnoreKeyboardChanges;

@property (nonatomic) BOOL shouldUseTheme;

// We often want to pin one view to the bottom of a view controller
// BUT adjust its location upward if the keyboard appears.
- (void)autoPinViewToBottomOfViewControllerOrKeyboard:(UIView *)view avoidNotch:(BOOL)avoidNotch;
- (void)autoPinViewToBottomOfViewControllerOrKeyboard:(UIView *)view avoidNotch:(BOOL)avoidNotch withInset:(CGFloat)inset;
- (void)autoPinViewToBottomOfViewControllerOrKeyboard:(UIView *)view avoidNotch:(BOOL)avoidNotch withInset:(CGFloat)inset saveInset:(BOOL)saveInset;
- (void)setupStatusBar:(CGSize)size color:(UIColor*)color;
- (void)updateStatusBarAppearance:(UIColor*)color;
// If YES, the bottom view never "reclaims" layout space if the keyboard is dismissed.
// Defaults to NO.
@property (nonatomic) BOOL shouldBottomViewReserveSpaceForKeyboard;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (void)setup;
@end

NS_ASSUME_NONNULL_END
