// WDStarRatingView.swift
//
// Copyright (c) 2015 Wu Di, Sudeep Agarwal and Hugo Sousa
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

import UIKit

@objc public protocol WDStarRatingDelegate {
    optional func starRatingView(starRatingView: WDStarRatingView, didDrawStarsWithValue value: CGFloat)
    optional func starRatingView(starRatingView: WDStarRatingView, didUpdateToValue value: CGFloat)
    optional func starRatingView(starRatingView: WDStarRatingView, didStartTracking tracking: Bool)
    optional func starRatingView(starRatingView: WDStarRatingView, didStopTracking tracking: Bool)
}

@IBDesignable public class WDStarRatingView: UIControl {
    private var _minimumValue: Int!
    private var _maximumValue: Int!
    private var _value: CGFloat!
    private var _spacing: CGFloat!
    private var _previousValue: CGFloat?
    private var _arrayOfFrames: [CGRect]!
    private var _allowsHalfStars = true

    // MARK: Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)

        _customInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        _customInit()
    }

    private func _customInit() {
        self.backgroundColor = UIColor.clearColor()
        self.exclusiveTouch = true
        _minimumValue = 1
        _maximumValue = 5
        _value = 0
        _spacing = 5
        _arrayOfFrames = []
    }

    // MARK: Properties

    public var delegate: WDStarRatingDelegate?

    @IBInspectable public var allowsHalfStars: Bool {
        get {
            return _allowsHalfStars
        }
        set {
            _allowsHalfStars = newValue
        }
    }

    @IBInspectable public var minimumValue: Int {
        get {
            return max(_minimumValue, 0)
        }
        set {
            if _minimumValue != newValue {
                _minimumValue = newValue
                self.setNeedsDisplay()
            }
        }
    }

    @IBInspectable public var maximumValue: Int {
        get {
            return max(_minimumValue, _maximumValue)
        }
        set {
            if _maximumValue != newValue {
                _maximumValue = newValue
                self.setNeedsDisplay()
                self.invalidateIntrinsicContentSize()
            }
        }
    }

    @IBInspectable public var value: CGFloat {
        get {
            return min(max(_value, CGFloat(_minimumValue)), CGFloat(_maximumValue))
        }
        set {
            if _value != newValue {
                _value = newValue
                self.sendActionsForControlEvents(.ValueChanged)
                self.setNeedsDisplay()
            }
        }
    }

    @IBInspectable public var spacing: CGFloat {
        get {
            return _spacing
        }
        set {
            _spacing = max(newValue, 0)
            self.setNeedsDisplay()
        }
    }

    // MARK: Drawing

    private func _drawStarWithFrame(frame: CGRect, tintColor: UIColor, highlighted: Bool) {
        let starShapePath = UIBezierPath()

        starShapePath.moveToPoint(CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.02500 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.37292 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.02500 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.30504 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.20642 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.78265 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.79358 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.69501 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.97500 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame)))
        starShapePath.closePath()
        starShapePath.miterLimit = 4;

        if highlighted {
            tintColor.setFill()
            starShapePath.fill()
        }

        tintColor.setStroke()
        starShapePath.lineWidth = 1
        starShapePath.stroke()
    }

    private func _drawHalfStarWithFrame(frame: CGRect, tintColor: UIColor, highlighted: Bool) {
        let starShapePath = UIBezierPath()

        starShapePath.moveToPoint(CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.02500 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.37292 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.02500 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.30504 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.20642 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.78265 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame),
            CGRectGetMinY(frame) + 0.02500 * CGRectGetHeight(frame)))
        starShapePath.closePath()
        starShapePath.miterLimit = 4;

        if highlighted {
            tintColor.setFill()
            starShapePath.fill()
        }

        tintColor.setStroke()
        starShapePath.lineWidth = 1;
        starShapePath.stroke()
    }

    public override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, self.backgroundColor!.CGColor)
        CGContextFillRect(context, rect);

        let availableWidth = rect.size.width - (_spacing * CGFloat(_maximumValue + 1))
        let cellWidth = (availableWidth / CGFloat(_maximumValue))
        let starSide = (cellWidth <= rect.size.height) ? cellWidth : rect.size.height

        for index in 0..<_maximumValue {
            let idx = CGFloat(index)
            let center = CGPointMake(
                cellWidth * idx + cellWidth / 2 + _spacing * (idx + 1),
                rect.size.height / 2
            )
            let frame = CGRectMake(center.x - starSide / 2, center.y - starSide / 2, starSide, starSide)
            let highlighted = idx + 1 <= ceil(_value)
            let halfStar = highlighted ? (idx + 1 > _value) : false

            if halfStar && _allowsHalfStars {
                self._drawStarWithFrame(frame, tintColor: self.tintColor, highlighted: false)
                self._drawHalfStarWithFrame(frame, tintColor: self.tintColor, highlighted: highlighted)
            } else {
                self._drawStarWithFrame(frame, tintColor: self.tintColor, highlighted: highlighted)
            }

            self._arrayOfFrames.append(frame)
        }

        self.delegate?.starRatingView?(self, didDrawStarsWithValue: _value)
    }

    public override func setNeedsLayout() {
        super.setNeedsLayout()
        self.setNeedsDisplay()
    }

    public func starForValue(value: CGFloat) -> CGRect? {
        if value > 0 && value <= CGFloat(maximumValue) {
            return self._arrayOfFrames[Int(value + 0.5) - 1]
        } else if value == 0 {
            return self._arrayOfFrames.first
        } else {
            return nil
        }
    }

    // MARK: Touches

    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)

        if !self.isFirstResponder() {
            self.becomeFirstResponder()
        }

        _previousValue = _value
        self._handleTouch(touch)
        self.delegate?.starRatingView?(self, didStartTracking: true)

        return true
    }

    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        self._handleTouch(touch)

        return true
    }

    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        if touch == nil {
            return
        }
        super.endTrackingWithTouch(touch, withEvent: event)

        if self.isFirstResponder() {
            self.resignFirstResponder()
        }

        self._handleTouch(touch!)

        if _value != _previousValue {
            self.sendActionsForControlEvents(.ValueChanged)
        }

        self.delegate?.starRatingView?(self, didStopTracking: true)
    }

    public override func cancelTrackingWithEvent(event: UIEvent?) {
        super.cancelTrackingWithEvent(event)

        if self.isFirstResponder() {
            self.resignFirstResponder()
        }
    }

    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !self.userInteractionEnabled
    }

    private func _handleTouch(touch: UITouch) {
        let cellWidth = self.bounds.size.width / CGFloat(_maximumValue)
        let location = touch.locationInView(self)
        let value = location.x / cellWidth

        if _allowsHalfStars && value + 0.5 < ceil(value) {
            _value = floor(value) + 0.5
        } else {
            _value = ceil(value)
        }

        self.setNeedsDisplay()
        self.delegate?.starRatingView?(self, didUpdateToValue: _value)
    }

    // MARK: First Responder

    public override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Intrinsic Content Size
    
    public override func intrinsicContentSize() -> CGSize {
        let height: CGFloat = 44
        
        return CGSizeMake(
            CGFloat(_maximumValue) * height + CGFloat(_maximumValue + 1) * _spacing,
            height
        )
    }
}