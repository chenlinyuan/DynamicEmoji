//
// CharacterLocationSeeker.m
// Version 0.0.2 Created on 16/1/05
//
// Copyright (c) 2015 FasaMo ( http://github.com/FasaMo ; http://weibo.com/FasaMo )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CharacterLocationSeeker.h"

@interface CharacterLocationSeeker ()
@property (strong, nonatomic) NSTextStorage *textStorage;
@property (strong, nonatomic) NSLayoutManager *layoutManager;
@property (strong, nonatomic) NSTextContainer *textContainer;
@end

@implementation CharacterLocationSeeker

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupBasic];
    }
    return self;
}

- (void)setupBasic
{
    self.textStorage = [NSTextStorage new];
    self.layoutManager = [NSLayoutManager new];
    self.textContainer = [NSTextContainer new];
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
}

- (void)configWithLabel:(UILabel *)label
{
    self.textContainer.size = label.bounds.size;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.maximumNumberOfLines = label.numberOfLines;
    self.textContainer.lineBreakMode = label.lineBreakMode;
    [self.textStorage setAttributedString:label.attributedText];
}

- (CGRect)characterRectofRange:(NSRange)range
{
    NSRange characterRange = range;
    NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:characterRange actualCharacterRange:nil];
    return [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
}

- (BOOL)isTruncatedAtIndex:(NSUInteger)index {
    return [self.layoutManager truncatedGlyphRangeInLineFragmentForGlyphAtIndex:index].location != NSNotFound;
}

- (NSRange)truncatedRange {
    NSRange truncatedrange = [self.layoutManager truncatedGlyphRangeInLineFragmentForGlyphAtIndex:0];
    return truncatedrange;
}

@end
