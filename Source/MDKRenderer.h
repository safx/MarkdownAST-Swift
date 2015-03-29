//
//  MDKRenderer.h
//  MarkdownKit
//
//  Created by Safx Developer on 2015/03/20.
//  Copyright (c) 2015年 Safx Developers. All rights reserved.
//

#include "document.h"

// block level callbacks
typedef void (^MDKBlockcodeBlock)(void* node, NSString* text, NSString* lang);
typedef void (^MDKBlockquoteBlock)(void* node, void* content);
typedef void (^MDKHeaderBlock)(void* node, void* content, int level);
typedef void (^MDKHruleBlock)(void* node);
typedef void (^MDKListBlock)(void* node, void* content, hoedown_list_flags flags);
typedef void (^MDKListitemBlock)(void* node, void* content, hoedown_list_flags flags);
typedef void (^MDKParagraphBlock)(void* node, void* content);
typedef void (^MDKTableBlock)(void* node, void* content);
typedef void (^MDKTable_headerBlock)(void* node, void* content);
typedef void (^MDKTable_bodyBlock)(void* node, void* content);
typedef void (^MDKTable_rowBlock)(void* node, void* content);
typedef void (^MDKTable_cellBlock)(void* node, void* content, hoedown_table_flags flags);
typedef void (^MDKFootnotesBlock)(void* node, void* content);
typedef void (^MDKFootnote_defBlock)(void* node, void* content, unsigned int num);
typedef void (^MDKBlockhtmlBlock)(void* node, NSString* text);

// span level callbacks
typedef int (^MDKAutolinkBlock)(void* node, NSString* link, hoedown_autolink_type type);
typedef int (^MDKCodespanBlock)(void* node, NSString* text);
typedef int (^MDKDouble_emphasisBlock)(void* node, void* content);
typedef int (^MDKEmphasisBlock)(void* node, void* content);
typedef int (^MDKUnderlineBlock)(void* node, void* content);
typedef int (^MDKHighlightBlock)(void* node, void* content);
typedef int (^MDKQuoteBlock)(void* node, void* content);
typedef int (^MDKImageBlock)(void* node, NSString* link, NSString* title, NSString* alt);
typedef int (^MDKLinebreakBlock)(void* node);
typedef int (^MDKLinkBlock)(void* node, void* content, NSString* link, NSString* title);
typedef int (^MDKTriple_emphasisBlock)(void* node, void* content);
typedef int (^MDKStrikethroughBlock)(void* node, void* content);
typedef int (^MDKSuperscriptBlock)(void* node, void* content);
typedef int (^MDKFootnote_refBlock)(void* node, unsigned int num);
typedef int (^MDKMathBlock)(void* node, NSString* text, int displaymode);
typedef int (^MDKRaw_htmlBlock)(void* node, NSString* text);

// low level callbacks
typedef void (^MDKEntityBlock)(void* node, NSString* text);
typedef void (^MDKNormal_textBlock)(void* node, NSString* text);

// miscellaneous callbacks
typedef void (^MDKDoc_headerBlock)(void* node, int inline_render);
typedef void (^MDKDoc_footerBlock)(void* node, int inline_render);

// MARK: Hoedown object
typedef void* (^MDKSpan_newBlock)(enum hoedown_span_type);
typedef void* (^MDKBlock_newBlock)(enum hoedown_block_type);
typedef void (^MDKSpan_freeBlock)(void* node, enum hoedown_span_type);
typedef void (^MDKBlock_freeBlock)(void* node, enum hoedown_block_type);


@interface MDKRenderer : NSObject
// block level callbacks - NULL toskips the block in pargraph or fallthrough to paragraph otherwise
@property (nonatomic, strong) MDKBlockcodeBlock blockcode;
@property (nonatomic, strong) MDKBlockquoteBlock blockquote;
@property (nonatomic, strong) MDKHeaderBlock header;
@property (nonatomic, strong) MDKHruleBlock hrule;
@property (nonatomic, strong) MDKListBlock list;
@property (nonatomic, strong) MDKListitemBlock listitem;
@property (nonatomic, strong) MDKParagraphBlock paragraph;
@property (nonatomic, strong) MDKTableBlock table;
@property (nonatomic, strong) MDKTable_headerBlock table_header;
@property (nonatomic, strong) MDKTable_bodyBlock table_body;
@property (nonatomic, strong) MDKTable_rowBlock table_row;
@property (nonatomic, strong) MDKTable_cellBlock table_cell;
@property (nonatomic, strong) MDKFootnotesBlock footnotes;
@property (nonatomic, strong) MDKFootnote_defBlock footnote_def;
@property (nonatomic, strong) MDKBlockhtmlBlock blockhtml;

// span level callbacks - NULL or return nil prints the span verbatim
@property (nonatomic, strong) MDKAutolinkBlock autolink;
@property (nonatomic, strong) MDKCodespanBlock codespan;
@property (nonatomic, strong) MDKDouble_emphasisBlock double_emphasis;
@property (nonatomic, strong) MDKEmphasisBlock emphasis;
@property (nonatomic, strong) MDKUnderlineBlock underline;
@property (nonatomic, strong) MDKHighlightBlock highlight;
@property (nonatomic, strong) MDKQuoteBlock quote;
@property (nonatomic, strong) MDKImageBlock image;
@property (nonatomic, strong) MDKLinebreakBlock linebreak;
@property (nonatomic, strong) MDKLinkBlock link;
@property (nonatomic, strong) MDKTriple_emphasisBlock triple_emphasis;
@property (nonatomic, strong) MDKStrikethroughBlock strikethrough;
@property (nonatomic, strong) MDKSuperscriptBlock superscript;
@property (nonatomic, strong) MDKFootnote_refBlock footnote_ref;
@property (nonatomic, strong) MDKMathBlock math;
@property (nonatomic, strong) MDKRaw_htmlBlock raw_html;

// low level callbacks - NULL copies input directly into the output
@property (nonatomic, strong) MDKEntityBlock entity;
@property (nonatomic, strong) MDKNormal_textBlock normal_text;

// miscellaneous callbacks
@property (nonatomic, strong) MDKDoc_headerBlock doc_header;
@property (nonatomic, strong) MDKDoc_footerBlock doc_footer;

// MARK: Hoedown object
@property (nonatomic, strong) MDKSpan_newBlock span_new;
@property (nonatomic, strong) MDKBlock_newBlock block_new;
@property (nonatomic, strong) MDKSpan_freeBlock span_free;
@property (nonatomic, strong) MDKBlock_freeBlock block_free;


- (void*)parse:(NSString*)markdownText;
- (void*)parse:(NSString*)markdownText extensions:(enum hoedown_extensions)extensions;
@end


@interface MDKHTMLRenderer : NSObject
- (instancetype)initWithFlags:(int)flags; // FIXME: use enum
- (NSString*)parse:(NSString*)markdownText;
- (NSString*)parse:(NSString*)markdownText extensions:(enum hoedown_extensions)extensions;
@end
