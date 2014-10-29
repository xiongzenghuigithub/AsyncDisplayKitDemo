

#import "BlurbNode.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <AsyncDisplayKit/ASHighlightOverlayLayer.h>

static CGFloat kTextPadding = 10.0f;
static NSString * kLinkAttributeName = @"PlaceKittenNodeLinkAttributeName";

@interface BlurbNode () <ASTextNodeDelegate> {
    ASTextNode *_textNode;
}

@end

@implementation BlurbNode

- (id)init {

    _textNode = [[ASTextNode alloc] init];
    _textNode.delegate = self;
    _textNode.userInteractionEnabled = YES;
    _textNode.linkAttributeNames = @[kLinkAttributeName];
    
    NSString *blurb = @"kittens courtesy placekitten.com \U0001F638";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:blurb];
    
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f] range:NSMakeRange(0, blurb.length)];
    
    [string addAttributes:@{
                            kLinkAttributeName: [NSURL URLWithString:@"http://placekitten.com/"],
                            NSForegroundColorAttributeName: [UIColor grayColor],
                            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternDot),
                            }
                    range:[blurb rangeOfString:@"placekitten.com"]];
    
    _textNode.attributedString = string;
    
    [self addSubnode:_textNode];
    
    return self;
}

#pragma mark - ASDisplayNode的回调函数
- (void)didLoad {
    self.layer.as_allowsHighlightDrawing = YES;
    [super didLoad];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize measuredSize = [_textNode measure:CGSizeMake(constrainedSize.width - 2 * kTextPadding,
                                                        constrainedSize.height - 2 * kTextPadding)];
    return CGSizeMake(constrainedSize.width, measuredSize.height + 2 * kTextPadding);
}

- (void)layout {
    
    CGSize textNodeSize = _textNode.calculatedSize;
    _textNode.frame = CGRectMake(roundf((self.calculatedSize.width - textNodeSize.width) / 2.0f),
                                 kTextPadding,
                                 textNodeSize.width,
                                 textNodeSize.height);
}

#pragma mark - ASTextNodeDelegate
- (BOOL)textNode:(ASTextNode *)richTextNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value
{
    return YES;
}

- (void)textNode:(ASTextNode *)richTextNode tappedLinkAttribute:(NSString *)attribute value:(NSURL *)URL atPoint:(CGPoint)point textRange:(NSRange)textRange
{
    [[UIApplication sharedApplication] openURL:URL];
}

@end
