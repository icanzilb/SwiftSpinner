//
// Copyright (c) 2015-present Marin Todorov, Underplot ltd.
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

public class SwiftSpinner: UIView {
    fileprivate static let standardAnimationDuration = 0.33

   // MARK: - Singleton

    //
    // Access the singleton instance
    //
    public static let shared = SwiftSpinner(frame: CGRect.zero)

    // MARK: - Init

    /// Init
    ///
    /// - Parameter frame: the view's frame
    public override init(frame: CGRect) {
        currentTitleFont = defaultTitleFont // By default we initialize to the same.

        super.init(frame: frame)

        blurEffect = UIBlurEffect(style: blurEffectStyle)
        blurView = UIVisualEffectView()
        addSubview(blurView)

        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        addSubview(vibrancyView)

        let titleScale: CGFloat = 0.85
        titleLabel.frame.size = CGSize(width: frameSize.width * titleScale, height: frameSize.height * titleScale)
        titleLabel.font = currentTitleFont
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = UIColor.white

        blurView.contentView.addSubview(titleLabel)
        blurView.contentView.addSubview(vibrancyView)

        outerCircleView.frame.size = frameSize

        outerCircle.path = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: frameSize.width, height: frameSize.height)).cgPath
        outerCircle.lineWidth = 8.0
        outerCircle.strokeStart = 0.0
        outerCircle.strokeEnd = 0.45
        outerCircle.lineCap = .round
        outerCircle.fillColor = UIColor.clear.cgColor
        outerCircle.strokeColor = outerCircleDefaultColor
        outerCircleView.layer.addSublayer(outerCircle)

        outerCircle.strokeStart = 0.0
        outerCircle.strokeEnd = 1.0

        blurView.contentView.addSubview(outerCircleView)

        innerCircleView.frame.size = frameSize

        let innerCirclePadding: CGFloat = 12
        innerCircle.path = UIBezierPath(ovalIn: CGRect(x: innerCirclePadding, y: innerCirclePadding, width: frameSize.width - 2*innerCirclePadding, height: frameSize.height - 2*innerCirclePadding)).cgPath
        innerCircle.lineWidth = 4.0
        innerCircle.strokeStart = 0.5
        innerCircle.strokeEnd = 0.9
        innerCircle.lineCap = .round
        innerCircle.fillColor = UIColor.clear.cgColor
        innerCircle.strokeColor = innerCircleDefaultColor
        innerCircleView.layer.addSublayer(innerCircle)

        innerCircle.strokeStart = 0.0
        innerCircle.strokeEnd = 1.0

        blurView.contentView.addSubview(innerCircleView)

        isUserInteractionEnabled = true
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }

    // MARK: - Public interface

    /// The label with the spinner's title
    public lazy var titleLabel = UILabel()

    /// The label with the spinner's subtitle
    public var subtitleLabel: UILabel?

    private let outerCircleDefaultColor = UIColor.white.cgColor
    fileprivate var _outerColor: UIColor?

    /// The color of the outer circle
    public var outerColor: UIColor? {
        get { return _outerColor }
        set(newColor) {
            _outerColor = newColor
            outerCircle.strokeColor = newColor?.cgColor ?? outerCircleDefaultColor
        }
    }

    private let innerCircleDefaultColor = UIColor.gray.cgColor
    fileprivate var _innerColor: UIColor?

    /// The color of the inner circle
    public var innerColor: UIColor? {
        get { return _innerColor }
        set(newColor) {
            _innerColor = newColor
            innerCircle.strokeColor = newColor?.cgColor ?? innerCircleDefaultColor
        }
    }

    /// Custom superview for the spinner
    private static weak var customSuperview: UIView?
    private static func containerView() -> UIView? {
        #if EXTENSION
            return customSuperview
        #else
            return customSuperview ?? UIApplication.shared.keyWindow
        #endif
    }

    /// Custom container for the spinner
    public class func useContainerView(_ sv: UIView?) {
        customSuperview = sv
    }

    /// Show the blurred background. If false the background content will be visible. Defaults to true.
    public static var showBlurBackground: Bool = true

    /// Show the spinner activity on screen, if visible only update the title
    ///
    /// - Parameters:
    ///   - title: The title shown under the spiiner
    ///   - animated: Animate the spinner. Defaults to true
    /// - Returns: The instance of the spinner
    @discardableResult
    public class func show(_ title: String, animated: Bool = true) -> SwiftSpinner {
        let spinner = SwiftSpinner.shared

        spinner.clearTapHandler()

        spinner.updateFrame()

        if spinner.superview == nil {
            // Show the spinner
            spinner.blurView.contentView.alpha = 0

            guard let containerView = containerView() else {
                #if EXTENSION
                    fatalError("\n`containerView` is `nil`. `UIApplication.keyWindow` is not available in extensions and so, a containerView is required. Use `useContainerView` to set a view where the spinner should show")
                #else
                    fatalError("\n`UIApplication.keyWindow` is `nil`. If you're trying to show a spinner from your view controller's `viewDidLoad` method, do that from `viewWillAppear` instead. Alternatively use `useContainerView` to set a view where the spinner should show")
                #endif
            }

            containerView.addSubview(spinner)

            UIView.animate(withDuration: SwiftSpinner.standardAnimationDuration, delay: 0.0, options: .curveEaseOut, animations: {
                spinner.blurView.contentView.alpha = 1
                spinner.blurView.effect = showBlurBackground ? spinner.blurEffect : .none
            }, completion: nil)

            #if os(iOS)
                // Orientation change observer
                NotificationCenter.default.addObserver(
                    spinner,
                    selector: #selector(SwiftSpinner.updateFrame),
                    name: UIApplication.didChangeStatusBarOrientationNotification,
                    object: nil)
            #endif
        } else if spinner.dismissing {
            // If the spinner is hiding, delay the next show. The duration is set to double the standard animation to avoid an edge case that caused endless laoding. See #125
            show(delay: SwiftSpinner.standardAnimationDuration, title: title, animated: true)
        }

        spinner.title = title
        spinner.animating = animated

        return spinner
    }

    /// Show the spinner activity on screen with duration, if visible only update the title
    ///
    /// - Parameters:
    ///   - duration: The duration of the show animation
    ///   - title: The title shown under the spinner
    ///   - animated: Animate the spinner. Defaults to true
    ///   - completion: An optional completion handler
    /// - Returns: The instance of the spinner
    @discardableResult
    public class func show(duration: Double, title: String, animated: Bool = true, completion: (() -> ())? = nil) -> SwiftSpinner {
        let spinner = SwiftSpinner.show(title, animated: animated)
        spinner.delay(duration) {
            SwiftSpinner.hide {
                completion?()
            }
        }
        return spinner
    }

    private static var delayedTokens = [String]()

    /// Show the spinner activity on screen, after delay. If new call to show, showWithDelay or hide is maked before execution this call is discarded
    ///
    /// - Parameters:
    ///   - delay: The delay time
    ///   - title: The title shown under the spinner
    ///   - animated: Animate the spinner. Defaults to true
    public class func show(delay: Double, title: String, animated: Bool = true) {
        let token = UUID().uuidString
        delayedTokens.append(token)
        SwiftSpinner.shared.delay(delay, completion: {
            if let index = delayedTokens.firstIndex(of: token) {
                delayedTokens.remove(at: index)
                SwiftSpinner.show(title, animated: animated)
            }
        })
    }

    /// Show the spinner with the outer circle representing progress (0 to 1)
    ///
    /// - Parameters:
    ///   - progress: The progress percentage. Values between 0 and 1
    ///   - title: The title shown under the spinner
    /// - Returns: The instance of the spinner
    @discardableResult
    public class func show(progress: Double, title: String) -> SwiftSpinner {
        let spinner = SwiftSpinner.show(title, animated: false)
        spinner.outerCircle.strokeEnd = CGFloat(progress)
        return spinner
    }

    /// If set to true, hiding a spinner causes scheduled spinners to be canceled
    public static var hideCancelsScheduledSpinners = true

    /// Hide the spinner
    ///
    /// - Parameter completion: A closure called upon completion
    public class func hide(_ completion: (() -> Void)? = nil) {
        let spinner = SwiftSpinner.shared

        spinner.dismissing = true

        NotificationCenter.default.removeObserver(spinner)
        if hideCancelsScheduledSpinners {
            delayedTokens.removeAll()
        }

        DispatchQueue.main.async(execute: {
            spinner.clearTapHandler()

            if spinner.superview == nil {
                spinner.dismissing = false
                return
            }

            UIView.animate(withDuration: SwiftSpinner.standardAnimationDuration, delay: 0.0, options: .curveEaseOut, animations: {
                spinner.blurView.contentView.alpha = 0
                spinner.blurView.effect = nil
            }, completion: {_ in
                spinner.blurView.contentView.alpha = 1
                spinner.removeFromSuperview()
                spinner.titleLabel.text = nil
                spinner.dismissing = false

                completion?()
            })

            spinner.animating = false
        })
    }

    /// Set the default title font
    ///
    /// - Parameter font: The title font
    public class func setTitleFont(_ font: UIFont?) {
        let spinner = SwiftSpinner.shared

        spinner.currentTitleFont = font ?? spinner.defaultTitleFont
        spinner.titleLabel.font = font ?? spinner.defaultTitleFont
    }

    /// Set the default title color
    ///
    /// - Parameter color: The title color
    public class func setTitleColor(_ color: UIColor?) {
        let spinner = SwiftSpinner.shared

        spinner.titleLabel.textColor = color ?? spinner.defaultTitleColor
    }

    /// The spinner title
    public var title: String = "" {
        didSet {
            let spinner = SwiftSpinner.shared

            guard spinner.animating else {
                spinner.titleLabel.transform = CGAffineTransform.identity
                spinner.titleLabel.alpha = 1.0
                spinner.titleLabel.text = self.title
                return
            }

            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                spinner.titleLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                spinner.titleLabel.alpha = 0.2
                }, completion: { _ in
                    spinner.titleLabel.text = self.title
                    UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.0, options: [], animations: {
                        spinner.titleLabel.transform = CGAffineTransform.identity
                        spinner.titleLabel.alpha = 1.0
                        }, completion: nil)
            })
        }
    }

    /// Observe the view frame and update the subviews layout
    public override var frame: CGRect {
        didSet {
            if frame == CGRect.zero {
                return
            }
            blurView.frame = bounds
            vibrancyView.frame = blurView.bounds
            titleLabel.center = vibrancyView.center
            outerCircleView.center = vibrancyView.center
            innerCircleView.center = vibrancyView.center
            layoutSubtitle()
        }
    }

    /// Start the spinning animation
    public var animating: Bool = false {

        willSet (shouldAnimate) {
            if shouldAnimate && !animating {
                spinInner()
                spinOuter()
            }
        }

        didSet {
            // Update UI
            if animating {
                self.outerCircle.strokeStart = 0.0
                self.outerCircle.strokeEnd = 0.45
                self.innerCircle.strokeStart = 0.5
                self.innerCircle.strokeEnd = 0.9
            } else {
                self.outerCircle.strokeStart = 0.0
                self.outerCircle.strokeEnd = 1.0
                self.innerCircle.strokeStart = 0.0
                self.innerCircle.strokeEnd = 1.0
            }
        }
    }

    /// Tap handler
    ///
    /// - Parameters:
    ///   - tap: The tap handler closure
    ///   - subtitleText: The optional subtitle
    public func addTapHandler(_ tap: @escaping (() -> Void), subtitle subtitleText: String? = nil) {
        clearTapHandler()

        //vibrancyView.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("didTapSpinner")))
        tapHandler = tap

        if subtitleText != nil {
            subtitleLabel = UILabel()
            if let subtitle = subtitleLabel {
                subtitle.text = subtitleText
                subtitle.font = UIFont(name: self.currentTitleFont.familyName, size: currentTitleFont.pointSize * 0.8)
                subtitle.textColor = UIColor.white
                subtitle.numberOfLines = 0
                subtitle.textAlignment = .center
                subtitle.lineBreakMode = .byWordWrapping
                layoutSubtitle()
                vibrancyView.contentView.addSubview(subtitle)
            }
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        if tapHandler != nil {
            tapHandler?()
            tapHandler = nil
        }
    }

    /// Remove the tap handler
    public func clearTapHandler() {
        isUserInteractionEnabled = false
        subtitleLabel?.removeFromSuperview()
        tapHandler = nil
    }

    // MARK: - Private interface

    //
    // Layout elements
    //

    private var blurEffectStyle: UIBlurEffect.Style = .dark
    private var blurEffect: UIBlurEffect!
    private var blurView: UIVisualEffectView!
    private var vibrancyView: UIVisualEffectView!

    private let defaultTitleFont = UIFont(name: "HelveticaNeue", size: 22.0)!
    private var currentTitleFont: UIFont

    private var defaultTitleColor = UIColor.white

    let frameSize = CGSize(width: 200.0, height: 200.0)

    private lazy var outerCircleView = UIView()
    private lazy var innerCircleView = UIView()

    private let outerCircle = CAShapeLayer()
    private let innerCircle = CAShapeLayer()

    required public init?(coder aDecoder: NSCoder) {
        fatalError("Not coder compliant")
    }

    private var currentOuterRotation: CGFloat = 0.0
    private var currentInnerRotation: CGFloat = 0.1

    private var dismissing: Bool = false

    private func spinOuter() {
        if superview == nil {
            return
        }

        let duration = Double(Float(arc4random()) /  Float(UInt32.max)) * 2.0 + 1.5
        let randomRotation = Double(Float(arc4random()) /  Float(UInt32.max)) * (Double.pi / 4) + (Double.pi / 4)

        //outer circle
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            self.currentOuterRotation -= CGFloat(randomRotation)
            self.outerCircleView.transform = CGAffineTransform(rotationAngle: self.currentOuterRotation)
            }, completion: {_ in
                let waitDuration = Double(Float(arc4random()) /  Float(UInt32.max)) * 1.0 + 1.0
                self.delay(waitDuration, completion: {
                    if self.animating {
                        self.spinOuter()
                    }
                })
        })
    }

    private func spinInner() {
        if superview == nil {
            return
        }

        //inner circle
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.currentInnerRotation += CGFloat(Double.pi / 4)
            self.innerCircleView.transform = CGAffineTransform(rotationAngle: self.currentInnerRotation)
            }, completion: { _ in
                self.delay(0.5, completion: {
                    if self.animating {
                        self.spinInner()
                    }
                })
        })
    }

    @objc public func updateFrame() {
        if let containerView = SwiftSpinner.containerView() {
            SwiftSpinner.shared.frame = containerView.bounds
            containerView.bringSubviewToFront(SwiftSpinner.shared)
        }
    }

    // MARK: - Util methods

    func delay(_ seconds: Double, completion:@escaping () -> Void) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)

        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }

    fileprivate func layoutSubtitle() {
        if let subtitle = subtitleLabel {
            subtitle.bounds.size = subtitle.sizeThatFits(bounds.insetBy(dx: 20.0, dy: 0.0).size)
            var safeArea: CGFloat = 0
            if #available(iOS 11.0, tvOS 11.0, *) {
                safeArea = superview?.safeAreaInsets.bottom ?? 0
            }
            subtitle.center = CGPoint(x: bounds.midX, y: bounds.maxY - subtitle.bounds.midY - subtitle.font.pointSize - safeArea)
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }

    // MARK: - Tap handler
    private var tapHandler: (() -> Void)?
    func didTapSpinner() {
        tapHandler?()
    }
}
