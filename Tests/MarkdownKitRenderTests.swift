//
//  MarkdownKitRenderTests.swift
//  MarkdownKit
//
//  Created by Safx Developer on 2015/03/23.
//  Copyright (c) 2015年 Safx Developers. All rights reserved.
//

import UIKit
import XCTest
import MarkdownKit

let MDKVoid = { (a: NSMutableArray) -> UnsafeMutablePointer<Void> in
    return unsafeBitCast(a, UnsafeMutablePointer<Void>.self)
}
let MDKObj = { (p: UnsafeMutablePointer<Void>) -> NSObject in
    return unsafeBitCast(p, NSObject.self)
}
let MDKArary = { (p: UnsafeMutablePointer<Void>) -> NSMutableArray in
    return unsafeBitCast(p, NSMutableArray.self)
}

class MarkdownKitRenderTests: XCTestCase {
    var renderer: MDKRenderer!
    var objectPool = NSMutableArray()

    override func setUp() {
        super.setUp()

        weak var pool = objectPool
        renderer = MDKRenderer()

        renderer.block_new = { type in
            let a = NSMutableArray()
            pool!.addObject(a)
            return MDKVoid(a)
        }

        renderer.span_new = { type in
            let a = NSMutableArray()
            pool!.addObject(a)
            return MDKVoid(a)
        }

        renderer.block_free = { node, type in
            pool!.removeObject(MDKObj(node))
        }
        renderer.span_free = { node, type in
            pool!.removeObject(MDKObj(node))
        }
        
        renderer.normal_text = { node_, text in
            let node = MDKArary(node_)
            node.addObject(text)
        }
    }

    override func tearDown() {
        super.tearDown()
        objectPool.removeAllObjects()
    }

    func testParagraph() {
        let expectation1 = expectationWithDescription("2")
        renderer.paragraph = { _, content_ in
            let content = MDKArary(content_)
            XCTAssertEqual(content.count, 1)
            XCTAssertEqual(content[0] as? NSString, "foo\nbar")
            expectation1.fulfill()
        }

        renderer.parse("foo\nbar")

        waitForExpectationsWithTimeout(3) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }

    func testBlockquote1() {
        let expectation1 = expectationWithDescription("1")
        renderer.paragraph = { _, content_ in
            let content = MDKArary(content_)
            XCTAssertEqual(content.count, 1)
            XCTAssertEqual(content[0] as? NSString, "foo")
            expectation1.fulfill()
        }

        let expectation3 = expectationWithDescription("3")
        renderer.blockquote = { text in
            expectation3.fulfill()
        }

        renderer.parse("> foo\n")

        waitForExpectationsWithTimeout(3) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }

    func testAST() {
        let node = parse("foo[bar](http://www.example.com)baz\n> foo\n bar\n\ntext\n\n```objc\nsome\ncode\n```")
        XCTAssertEqual("<body><p>foo<a href=\"http://www.example.com\">bar</a>baz</p><blockquote><p>foo\n bar</p></blockquote><p>text</p><pre>some\ncode\n</pre></body>", node.description)
    }
}

