//
//  MarkdownKitHTMLRenderTests.swift
//  MarkdownKitTests
//
//  Created by Safx Developer on 2015/03/13.
//  Copyright (c) 2015年 Safx Developers. All rights reserved.
//

import UIKit
import XCTest
import MarkdownKit

class MarkdownKitHTMLRenderTests: XCTestCase {
    var renderer: MDKHTMLRenderer!

    override func setUp() {
        super.setUp()
        renderer = MDKHTMLRenderer()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        XCTAssertEqual("<ul>\n<li>わたしの名前は</li>\n<li>中野です</li>\n</ul>\n", renderer.parse("* わたしの名前は\n* 中野です")!)
        XCTAssertEqual("<p>foo<a href=\"http://www.google.com\">bar</a>baz</p>\n", renderer.parse("foo[bar](http://www.google.com)baz")!)
    }
}
