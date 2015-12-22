//
//  MDKRenderer.m
//  MarkdownKit
//
//  Created by Safx Developer on 2015/03/20.
//  Copyright (c) 2015年 Safx Developers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDKRenderer.h"
#import "MarkdownKit.h"



inline static NSString* Str(const hoedown_buffer* buffer) {
    if (!buffer) return @"";
    return [[NSString alloc] initWithBytes:buffer->data length:buffer->size encoding:NSUTF8StringEncoding];
}

// MARK: block level callback helpers

#define GET_RENDERER \
	assert(data && data->opaque);                          \
    MDKRenderer* r = (__bridge MDKRenderer*) data->opaque;

#define HOEDOWN_CALLBACK_0(func) \
    GET_RENDERER                 \
    if (r.func) r.func(node);

#define HOEDOWN_CALLBACK_1(func, arg1) \
    GET_RENDERER                       \
    if (r.func) r.func(node, arg1);

#define HOEDOWN_CALLBACK_2(func, arg1, arg2) \
    GET_RENDERER                             \
    if (r.func) r.func(node, arg1, arg2);

#define HOEDOWN_CALLBACK_0_RET(func) \
    GET_RENDERER                     \
    return r.func ? r.func(node) : 0;

#define HOEDOWN_CALLBACK_1_RET(func, arg1) \
    GET_RENDERER                           \
    return r.func ? r.func(node, arg1) : 0;

#define HOEDOWN_CALLBACK_2_RET(func, arg1, arg2) \
    GET_RENDERER                                 \
    return r.func ? r.func(node, arg1, arg2) : 0;

#define HOEDOWN_CALLBACK_3_RET(func, arg1, arg2, arg3) \
    GET_RENDERER                                       \
    return r.func ? r.func(node, arg1, arg2, arg3) : 0;

#define HOEDOWN_CALLBACK_1_NEW(func, arg1) \
    GET_RENDERER                     \
    return r.func ? r.func(arg1) : 0;

#define HOEDOWN_CALLBACK_2_FREE(func, arg1, arg2) \
    GET_RENDERER                           \
    return r.func ? r.func(arg1, arg2) : 0;

// MARK: block level callbacks

static void render_blockcode(void* node, const hoedown_buffer *text, const hoedown_buffer *lang, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2(blockcode, Str(text), Str(lang));
}

static void render_blockquote(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(blockquote, content);
}

static void render_header(void* node, void *content, int level, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2(header, content, level);
}

static void render_hrule(void* node, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_0(hrule);
}

static void render_list(void* node, void *content, hoedown_list_flags flags, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2(list, content, flags);
}

static void render_listitem(void* node, void *content, hoedown_list_flags flags, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2(listitem, content, flags);
}

static void render_paragraph(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(paragraph, content);
}

static void render_table(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(table, content);
}

static void render_table_header(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(table_header, content);
}

static void render_table_body(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(table_body, content);
}

static void render_table_row(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(table_row, content);
}

static void render_table_cell(void* node, void *content, hoedown_table_flags flags, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2(table_cell, content, flags);
}

static void render_footnotes(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(footnotes, content);
}

static void render_footnote_def(void* node, void *content, unsigned int num, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2(footnote_def, content, num);
}

static void render_blockhtml(void* node, const hoedown_buffer *text, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(blockhtml, Str(text));
}

// MARK: span level callbacks

static int render_autolink(void* node, const hoedown_buffer *link, hoedown_autolink_type type, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2_RET(autolink, Str(link), type);
}

static int render_codespan(void* node, const hoedown_buffer *text, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(codespan, Str(text));
}

static int render_double_emphasis(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(double_emphasis, content);
}

static int render_emphasis(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(emphasis, content);
}

static int render_underline(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(underline, content);
}

static int render_highlight(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(highlight, content);
}

static int render_quote(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(quote, content);
}

static int render_image(void* node, const hoedown_buffer *link, const hoedown_buffer *title, const hoedown_buffer *alt, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_3_RET(image, Str(link), Str(title), Str(alt));
}

static int render_linebreak(void* node, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_0_RET(linebreak);
}

static int render_link(void* node, void *content, const hoedown_buffer *link, const hoedown_buffer *title, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_3_RET(link, content, Str(link), Str(title));
}

static int render_triple_emphasis(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(triple_emphasis, content);
}

static int render_strikethrough(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(strikethrough, content);
}

static int render_superscript(void* node, void *content, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(superscript, content);
}

static int render_footnote_ref(void* node, unsigned int num, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(footnote_ref, num);
}

static int render_math(void* node, const hoedown_buffer *text, int displaymode, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2_RET(math, Str(text), displaymode);
}

static int render_raw_html(void* node, const hoedown_buffer *text, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_RET(raw_html, Str(text));
}

// MARK: low level callbacks

static void render_entity(void* node, const hoedown_buffer *text, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(entity, Str(text));
}

static void render_normal_text(void* node, const hoedown_buffer *text, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(normal_text, Str(text));
}

// MARK: miscellaneous callbacks

static void render_doc_header(void* node, int inline_render, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(doc_header, inline_render);
}

static void render_doc_footer(void* node, int inline_render, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1(doc_footer, inline_render);
}

// MARK: Hoedown object

static void* render_span_new(enum hoedown_span_type type, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_NEW(span_new, type);
}

static void* render_block_new(enum hoedown_block_type type, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_1_NEW(block_new, type);
}

static void render_span_free(void* node, enum hoedown_span_type type, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2_FREE(span_free, node, type);
}

static void render_block_free(void* node, enum hoedown_block_type type, const hoedown_renderer_data *data) {
    HOEDOWN_CALLBACK_2_FREE(block_free, node, type);
}



inline static hoedown_document* render_document(hoedown_renderer* renderer, hoedown_buffer* buffer, enum hoedown_extensions extensions, NSString* markdownText) {
    NSUInteger inputLength = [markdownText lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char* inputChars = [markdownText UTF8String];

    hoedown_document* document = hoedown_document_new(renderer, extensions, 16);

    hoedown_document_render(document, buffer, (const uint8_t*) inputChars, inputLength);
    return document;
}



@interface MDKRenderer () {
    hoedown_renderer renderer;
}
@end


@implementation MDKRenderer

- (instancetype)init {
    self = [super init];
    if (!self) return self;

    renderer.opaque = (__bridge void*) self;

    return self;
}

- (void*)parse:(NSString*)markdownText {
    return [self parse:markdownText extensions:0];
}

- (void*)parse:(NSString*)markdownText extensions:(enum hoedown_extensions)extensions {
    hoedown_object output = self.block_new(HOEDOWN_NODE_DOCUMENT);
    hoedown_document* document = render_document(&renderer, output, extensions, markdownText);
    hoedown_document_free(document);
    return output;
}

#define DECLARE_SETTER(capname, varname)                    \
- (void)set ## capname:(MDK ## capname ## Block)block {     \
    _ ## varname = block;                                   \
    renderer.varname = block ? & render_ ## varname : nil ; \
}

DECLARE_SETTER(Blockcode        , blockcode);
DECLARE_SETTER(Blockquote       , blockquote);
DECLARE_SETTER(Header           , header);
DECLARE_SETTER(Hrule            , hrule);
DECLARE_SETTER(List             , list);
DECLARE_SETTER(Listitem         , listitem);
DECLARE_SETTER(Paragraph        , paragraph);
DECLARE_SETTER(Table            , table);
DECLARE_SETTER(Table_header     , table_header);
DECLARE_SETTER(Table_body       , table_body);
DECLARE_SETTER(Table_row        , table_row);
DECLARE_SETTER(Table_cell       , table_cell);
DECLARE_SETTER(Footnotes        , footnotes);
DECLARE_SETTER(Footnote_def     , footnote_def);
DECLARE_SETTER(Blockhtml        , blockhtml);

DECLARE_SETTER(Autolink         , autolink);
DECLARE_SETTER(Codespan         , codespan);
DECLARE_SETTER(Double_emphasis  , double_emphasis);
DECLARE_SETTER(Emphasis         , emphasis);
DECLARE_SETTER(Underline        , underline);
DECLARE_SETTER(Highlight        , highlight);
DECLARE_SETTER(Quote            , quote);
DECLARE_SETTER(Image            , image);
DECLARE_SETTER(Linebreak        , linebreak);
DECLARE_SETTER(Link             , link);
DECLARE_SETTER(Triple_emphasis  , triple_emphasis);
DECLARE_SETTER(Strikethrough    , strikethrough);
DECLARE_SETTER(Superscript      , superscript);
DECLARE_SETTER(Footnote_ref     , footnote_ref);
DECLARE_SETTER(Math             , math);
DECLARE_SETTER(Raw_html         , raw_html);

DECLARE_SETTER(Entity           , entity);
DECLARE_SETTER(Normal_text      , normal_text);

DECLARE_SETTER(Doc_header       , doc_header);
DECLARE_SETTER(Doc_footer       , doc_footer);

DECLARE_SETTER(Span_new         , span_new);
DECLARE_SETTER(Block_new        , block_new);
DECLARE_SETTER(Span_free        , span_free);
DECLARE_SETTER(Block_free       , block_free);

#undef DECLARE_SETTER

@end



@interface MDKHTMLRenderer () {
    hoedown_renderer* renderer;
}
@end

@implementation MDKHTMLRenderer

- (instancetype)init {
    return [self initWithFlags:0];
}

- (instancetype)initWithFlags:(int)flags {
    self = [super init];
    if (!self) return self;

    renderer = hoedown_html_renderer_new(flags, 0);

    return self;
}

- (void)dealloc {
    hoedown_html_renderer_free(renderer);
}

- (NSString*)parse:(NSString*)markdownText {
    return [self parse:markdownText extensions:0];
}

- (NSString*)parse:(NSString*)markdownText extensions:(enum hoedown_extensions)extensions {
    hoedown_buffer* outputBuffer = hoedown_buffer_new(64);
    hoedown_document* document = render_document(renderer, outputBuffer, extensions, markdownText);

    NSString* output = Str(outputBuffer);

    hoedown_buffer_free(outputBuffer);
    hoedown_document_free(document);

    return output;
}

@end


