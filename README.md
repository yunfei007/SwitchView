# SwitchView
类似头条的横向切换栏


#需要用到的方法
+ (CGSize)sizeOfText:(NSString *)text font:(CGFloat)font
{
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName,nil]];
    return size;
}
