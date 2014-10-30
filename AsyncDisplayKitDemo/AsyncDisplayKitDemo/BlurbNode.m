

#import "BlurbNode.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <AsyncDisplayKit/ASHighlightOverlayLayer.h>

static CGFloat kTextPadding = 10.0f;
static NSString * kLinkAttributeName = @"PlaceKittenNodeLinkAttributeName";

@interface BlurbNode () <ASTextNodeDelegate> {
    ASTextNode * _textNode;
    ASTextNode * _textNode2;
//    ASImageNode * _imageNode1;
    
    float y;
}

@end

@implementation BlurbNode

- (id)init {

    _textNode = [[ASTextNode alloc] init];
    _textNode.delegate = self;
    _textNode.userInteractionEnabled = YES;
    _textNode.linkAttributeNames = @[kLinkAttributeName];
    
    _textNode2 = [[ASTextNode alloc] init];
    _textNode.userInteractionEnabled = YES;
    _textNode2.linkAttributeNames = @[kLinkAttributeName];
    
//    _imageNode1 = [[ASImageNode alloc] init];
//    [_imageNode1 setNeedsDisplayWithCompletion:^(BOOL canceled) {
//        NSLog(@"哈哈 ASImageNode 显示图片完毕\n");
//    }];
    
    //XZH - 1. 设置ASTextNode显示的文字  (以及设置字符串的一些行为: 点击后跳转指定的url网页)
    NSString *blurb = @"kittens courtesy placekitten.com  哈哈哈哈哈哈哈哈哈  \U0001F638";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:blurb];
    
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f] range:NSMakeRange(0, blurb.length)];
    
    [string addAttributes:@{
                            kLinkAttributeName: [NSURL URLWithString:@"http://www.baidu.com/"],
                            NSForegroundColorAttributeName: [UIColor grayColor],
                            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternDot),
                            }
                    range:[blurb rangeOfString:@"placekitten.com"]];
    
    _textNode.attributedString = string;
    
    NSString * text = @"第二个ASTextNode要显示的内容  哈哈哈哈啊哈哈哈!";
    NSMutableAttributedString * string2 = [[NSMutableAttributedString alloc] initWithString:text];
    [string2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f] range:NSMakeRange(0, text.length)];
    _textNode2.attributedString = string2;
    
    
    [self addSubnode:_textNode];
    [self addSubnode:_textNode2];
//    [self addSubnode:_imageNode1];
    
    return self;
}

#pragma mark - ASDisplayNode的回调函数
- (void)didLoad {
    self.layer.as_allowsHighlightDrawing = YES;
    [super didLoad];
}

#pragma mark - calculateSizeThatFits: 计算当前BlurbNode的CGSize
- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //constrainedSize: 表示当前屏幕的总宽度和总高度(当前Node的宽度和高度不能超过)
    
    //Node的 mearsure:(CGSize(内容最大显示宽度, 内容最大显示高度)) 方法 , 计算出Node内部内容要显示的高度
    
    //_textNode的size
    CGSize _textNode_size = [_textNode measure:CGSizeMake(constrainedSize.width, constrainedSize.height )];
    
    //_textNode2的size
    CGSize _textNode2_size = [_textNode2 measure:CGSizeMake(constrainedSize.width  , constrainedSize.height)];
    
    CGSize totalSize = CGSizeMake(constrainedSize.width, (_textNode_size.height + _textNode2_size.height + kTextPadding * 3));
    
    return totalSize;   //返回BlurbNode的总高度和总宽度
}

#pragma  mark - layout 计算当前BlurbNode的内部 所有子Node frame
- (void)layout {
    
    //保存BlurbNode内部当前y坐标值(加一个Node，就累加Node的高度)
    y = 0;
    
    //1. 计算所有子Node的自己的CGSiz
    CGSize textNode1Size = _textNode.calculatedSize;    //效果同measure:
    CGSize textNode2Size = _textNode2.calculatedSize;
    
    _textNode.frame = CGRectMake(0,
                                 kTextPadding,
                                 textNode1Size.width,
                                 textNode1Size.height);
    
    y += kTextPadding + textNode1Size.height;
    
    _textNode2.frame = CGRectMake(0, y + kTextPadding, textNode2Size.width, textNode2Size.height);
    
    y += kTextPadding+ textNode2Size.height;
    
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
