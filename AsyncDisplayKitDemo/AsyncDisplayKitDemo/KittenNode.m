

#import "KittenNode.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

static const CGFloat kImageSize = 80.0f;
static const CGFloat kOuterPadding = 16.0f;
static const CGFloat kInnerPadding = 10.0f;

@interface KittenNode () {
    
    CGSize _kittenSize;
    ASImageNode *_imageNode;
    ASTextNode *_textNode;
    ASDisplayNode *_divider;
}
@end

@implementation KittenNode

+ (NSArray *)placeholders
{
    static NSArray *placeholders = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        placeholders = @[
                         @"Kitty ipsum dolor sit amet, purr sleep on your face lay down in your way biting, sniff tincidunt a etiam fluffy fur judging you stuck in a tree kittens.",
                         @"Lick tincidunt a biting eat the grass, egestas enim ut lick leap puking climb the curtains lick.",
                         @"Lick quis nunc toss the mousie vel, tortor pellentesque sunbathe orci turpis non tail flick suscipit sleep in the sink.",
                         @"Orci turpis litter box et stuck in a tree, egestas ac tempus et aliquam elit.",
                         @"Hairball iaculis dolor dolor neque, nibh adipiscing vehicula egestas dolor aliquam.",
                         @"Sunbathe fluffy fur tortor faucibus pharetra jump, enim jump on the table I don't like that food catnip toss the mousie scratched.",
                         @"Quis nunc nam sleep in the sink quis nunc purr faucibus, chase the red dot consectetur bat sagittis.",
                         @"Lick tail flick jump on the table stretching purr amet, rhoncus scratched jump on the table run.",
                         @"Suspendisse aliquam vulputate feed me sleep on your keyboard, rip the couch faucibus sleep on your keyboard tristique give me fish dolor.",
                         @"Rip the couch hiss attack your ankles biting pellentesque puking, enim suspendisse enim mauris a.",
                         @"Sollicitudin iaculis vestibulum toss the mousie biting attack your ankles, puking nunc jump adipiscing in viverra.",
                         @"Nam zzz amet neque, bat tincidunt a iaculis sniff hiss bibendum leap nibh.",
                         @"Chase the red dot enim puking chuf, tristique et egestas sniff sollicitudin pharetra enim ut mauris a.",
                         @"Sagittis scratched et lick, hairball leap attack adipiscing catnip tail flick iaculis lick.",
                         @"Neque neque sleep in the sink neque sleep on your face, climb the curtains chuf tail flick sniff tortor non.",
                         @"Ac etiam kittens claw toss the mousie jump, pellentesque rhoncus litter box give me fish adipiscing mauris a.",
                         @"Pharetra egestas sunbathe faucibus ac fluffy fur, hiss feed me give me fish accumsan.",
                         @"Tortor leap tristique accumsan rutrum sleep in the sink, amet sollicitudin adipiscing dolor chase the red dot.",
                         @"Knock over the lamp pharetra vehicula sleep on your face rhoncus, jump elit cras nec quis quis nunc nam.",
                         @"Sollicitudin feed me et ac in viverra catnip, nunc eat I don't like that food iaculis give me fish.",
                         ];
    });
    
    return placeholders;
}

- (instancetype)initWithKittenOfSize:(CGSize)size
{
    if (!(self = [super init]))
        return nil;
    
    _kittenSize = size;
    
    // kitten image, with a purple background colour serving as placeholder
    _imageNode = [[ASImageNode alloc] init];
    _imageNode.backgroundColor = [UIColor purpleColor];
    [self addSubnode:_imageNode];
    
    // lorem ipsum text, plus some nice styling
    _textNode = [[ASTextNode alloc] init];
    _textNode.attributedString = [[NSAttributedString alloc] initWithString:[self kittyIpsum]
                                                                 attributes:[self textStyle]];
    [self addSubnode:_textNode];
    
    // hairline cell separator
    _divider = [[ASDisplayNode alloc] init];
    _divider.backgroundColor = [UIColor lightGrayColor];
    [self addSubnode:_divider];
    
    // download a placekitten of the requested size
    [self fetchKitten];
    
    return self;
}

- (NSString *)kittyIpsum
{
    NSArray *placeholders = [KittenNode placeholders];
    u_int32_t ipsumCount = (u_int32_t)[placeholders count];
    u_int32_t location = arc4random_uniform(ipsumCount);
    u_int32_t length = arc4random_uniform(ipsumCount - location);
    
    NSMutableString *string = [placeholders[location] mutableCopy];
    for (u_int32_t i = location + 1; i < location + length; i++) {
        [string appendString:(i % 2 == 0) ? @"\n" : @"  "];
        [string appendString:placeholders[i]];
    }
    
    return string;
}

- (NSDictionary *)textStyle
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 0.5 * font.lineHeight;
    style.hyphenationFactor = 1.0;
    
    return @{ NSFontAttributeName: font,
              NSParagraphStyleAttributeName: style };
}

- (void)fetchKitten
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInteger width = roundl(_kittenSize.width);
    NSInteger height = roundl(_kittenSize.height);
    
#pragma mark - 异步请求服务器URL图片, 回调Block代码块中获取UIImage对象
    NSURL *kittenURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://placekitten.com/%zd/%zd", width, height]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:kittenURL]
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               //回调Block中获取responseData
                               if (connectionError || !data || !data.length)
                                   return;
                               _imageNode.image = [UIImage imageWithData:data];
                           }];
}

#pragma mark - 计算当前Cell的总高度和总宽度 (累加计算出得所有subNode的内容需要的宽度和高度)
- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize
{
    CGSize imageSize = CGSizeMake(kImageSize, kImageSize);
    CGSize textSize = [_textNode measure:CGSizeMake(constrainedSize.width - kImageSize - 2 * kOuterPadding - kInnerPadding,
                                                    constrainedSize.height)];
    
    // ensure there's room for the text
    CGFloat requiredHeight = MAX(textSize.height, imageSize.height);
    return CGSizeMake(constrainedSize.width, requiredHeight + 2 * kOuterPadding);
}

#pragma mark - 从新计算并设置 当前Cell内部所有subNode的frame
- (void)layout
{
    CGFloat pixelHeight = 1.0f / [[UIScreen mainScreen] scale];
    _divider.frame = CGRectMake(0.0f, 0.0f, self.calculatedSize.width, pixelHeight);
    
    _imageNode.frame = CGRectMake(kOuterPadding, kOuterPadding, kImageSize, kImageSize);
    
    CGSize textSize = _textNode.calculatedSize;
    _textNode.frame = CGRectMake(kOuterPadding + kImageSize + kInnerPadding, kOuterPadding, textSize.width, textSize.height);
}

@end
