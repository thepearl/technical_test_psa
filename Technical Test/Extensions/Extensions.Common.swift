import UIKit
import AVKit
import AVFoundation
import SafariServices




//MARK:  NAVIGATION CONTROLLER

func mainNavigationController() -> UINavigationController?
{
    guard
        let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let mainWindow = appDelegate.window,
        let rootViewController = mainWindow.rootViewController as? UINavigationController else
    { return nil}
    
    return rootViewController
}


//MARK:  VIEW CONTROLLER
extension UIViewController
{
    @IBAction func POP_BACK(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    class func instantiateFromStoryboard(_ name: String) -> Self
    {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T
    {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
    
    var hasTopNotch: Bool
    {
        if #available(iOS 13.0,  *)
        {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }
        else
        {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
    
}



//MARK:  TABLEVIEW, COLLECTIONVIEW & SCROLLVIEW

extension UIScrollView //  Return a UIScrollView current page index as an Integer
{
    var currentPage: Int
    {
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}

extension UITableView
{
    func reloadData(completion: @escaping () -> ())
    {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
            {_ in completion() }
    }
}

extension UITableView
{
    func animate()
    {
        reloadData()
        
        let cells = visibleCells
        let tableHeight: CGFloat = bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 0.7, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
}


public extension UICollectionViewCell
{
    static var reuseIdentifier: String
    {
        return String(describing: self)
    }
}

public extension UITableViewCell
{
    static var reuseIdentifier: String
    {
        return String(describing: self)
    }
}

public extension UICollectionView
{
    
    func registerCellClass(_ cellClass: AnyClass)
    {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass)
    {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    func reloadData(_ completion: @escaping () -> Void)
    {
        reloadData()
        DispatchQueue.main.async { completion() }
    }
}


extension UIScrollView
{
    func scrollToBottom(animated: Bool)
    {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
    
    func animateScrollToBottom(withDuration duration: TimeInterval, completion: (()->())? = nil)
    {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.setContentOffset(CGPoint.zero, animated: false)
        }, completion: { finish in
            if finish { completion?() }
        })
    }
    
    func animateScrollToBottomTop(withDuration duration: TimeInterval, completion: (()->())? = nil)
    {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            let desiredOffset = CGPoint(x: 0, y: -self.contentInset.top)
            self.setContentOffset(desiredOffset, animated: false)
        }, completion: { finish in
            if finish { completion?() }
        })
    }
}


//MARK:  STRING

extension String
{
    static func className(_ aClass: AnyClass) -> String
    {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}

extension String
{
    var english: String
    {
        return self.applyingTransform(StringTransform.toLatin, reverse: false) ?? self
    }
}


//MARK:  UIVIEW
public extension UIView
{
    class func fromNib<T: UIView>() -> T
    {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    @IBInspectable
    var cornerRadius: CGFloat
    {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat
    {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor
    {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadowOffset : CGSize{
        
        get{
            return layer.shadowOffset
        }set{
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable
    var shadowOpacity : Float {
        
        get{
            return layer.shadowOpacity
        }
        set {
            
            layer.shadowOpacity = newValue
            
        }
    }    
}


//MARK:  UITextField

class TextFieldPadding: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 27)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect
    {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += 7
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect
    {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= 7
        return textRect
    }
}

extension UITextField
{
    @IBInspectable var placeHolderColor: UIColor?
    {
        get
        {
            return self.placeHolderColor
        }
        set
        {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}



extension UIAlertController
{
    class func alert(title:String, msg:String, target: UIViewController)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                (result: UIAlertAction) -> Void in
            })
            target.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - ENUMERATIONS
enum PlaceholdingImages: String
{
    case white = "whiteBackground"
    case profile = "profilePlaceholder"
    case product = "productPlaceholder"
    case category = "ico_splash"
}

func heightCalculator(text: String, withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
{
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
    return ceil(boundingBox.height)
}

func widthCalculator(text: String, withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
{
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
    return ceil(boundingBox.width)
}



extension UIButton {
    func underline(_ color : UIColor?) {
        var mainColor : UIColor
        if let color = color {
            mainColor = color
        }
        else
        {
            mainColor = self.titleColor(for: .normal)!
        }
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: mainColor, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: mainColor, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}

extension UIView
{
    func verifySublayersBeforApplyingGradient()
    {
        if self.layer.sublayers != nil
        {
            self.layer.sublayers?.removeAll { (layer) -> Bool in
                layer.name == "id"
            }
        }
    }
    
    func applyGradient(colours: [UIColor]) -> Void
    {
        self.applyHorizontalGradientMethod(colours: colours)
    }
    
    func applyHorizontalGradientMethod(colours: [UIColor]) -> Void
    {
        self.verifySublayersBeforApplyingGradient()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "id"
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyVerticalGradient(colours: [UIColor]) -> Void
    {
        self.applyVerticalGradientMethod(colours: colours, locations: nil)
    }
    
    func applyVerticalGradientMethod(colours: [UIColor], locations: [NSNumber]?) -> Void
    {
        self.verifySublayersBeforApplyingGradient()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "id"
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}

open class GradientViewInitializer : UIView
{
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        backgroundColor = .clear
    }
}
open class GradientToCenterView: GradientViewInitializer
{
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        applyGradient(colours: [ .clear, #colorLiteral(red: 0.03921568627, green: 0.03529411765, blue: 0.03529411765, alpha: 0.2965806935) , .clear])
    }
}

open class GradientToBottomView: GradientViewInitializer
{
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        applyGradient(colours: [.clear , #colorLiteral(red: 0.03921568627, green: 0.03529411765, blue: 0.03529411765, alpha: 0.2965806935) ])
    }
}

open class GradientToTopView: GradientViewInitializer
{
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        applyGradient(colours: [ #colorLiteral(red: 0.03921568627, green: 0.03529411765, blue: 0.03529411765, alpha: 0.2965806935) , .clear])
    }
}


open class GradientToTopAndBottomView: GradientViewInitializer
{
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        applyGradient(colours: [ #colorLiteral(red: 0.03921568627, green: 0.03529411765, blue: 0.03529411765, alpha: 0.2965806935) , .clear, #colorLiteral(red: 0.03921568627, green: 0.03529411765, blue: 0.03529411765, alpha: 0.2965806935) ])
    }
}



extension UISegmentedControl
{
    func setTitleColor(_ color: UIColor, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: state)
    }
    
    func setTitleFont(_ font: UIFont, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.font] = font
        self.setTitleTextAttributes(attributes, for: state)
    }
    
}

class CheckBox: UIButton
{
    let checkedImage = UIImage(named: "checkBoxChecked")! as UIImage
    let uncheckedImage = UIImage(named: "checkBox")! as UIImage
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib()
    {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton)
    {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

extension AVAsset
{
    
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 2.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

extension UIImage
{
    
    static func imageByMergingImages(topImage: UIImage, bottomImage: UIImage, scaleForTop: CGFloat = 1.0) -> UIImage {
        let size = bottomImage.size
        let container = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        bottomImage.draw(in: container)
        
        let topWidth = size.width / scaleForTop
        let topHeight = size.height / scaleForTop
        let topX = (size.width / 2.0) - (topWidth / 2.0)
        let topY = (size.height / 2.0) - (topHeight / 2.0)
        
        topImage.draw(in: CGRect(x: topX, y: topY, width: topWidth, height: topHeight), blendMode: .normal, alpha: 1.0)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}


extension URL {
    func generateThumbnail() -> UIImage? {
        do {
            let asset = AVURLAsset(url: self)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)
            
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
}


extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Date {
    
    
    
    func addDays(n: Int) -> Date
    {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: n, to: self)!
    }
    
}

extension String
{
    func replace(string:String, replacement:String) -> String
    {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String
    {
        return self.replace(string: " ", replacement: "")
    }
}


@IBDesignable class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.red
    @IBInspectable var secondColor: UIColor = UIColor.green
    
    @IBInspectable var vertical: Bool = true
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    
    //MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

@IBDesignable class ThreeColorsGradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.red
    @IBInspectable var secondColor: UIColor = UIColor.green
    @IBInspectable var thirdColor: UIColor = UIColor.blue
    
    @IBInspectable var vertical: Bool = true {
        didSet {
            updateGradientDirection()
        }
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    
    //MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

@IBDesignable class RadialGradientView: UIView {
    
    @IBInspectable var outsideColor: UIColor = UIColor.red
    @IBInspectable var insideColor: UIColor = UIColor.green
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyGradient()
    }
    
    func applyGradient() {
        let colors = [insideColor.cgColor, outsideColor.cgColor] as CFArray
        let endRadius = sqrt(pow(frame.width/2, 2) + pow(frame.height/2, 2))
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        #if TARGET_INTERFACE_BUILDER
        applyGradient()
        #endif
    }
}

extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}

extension UILabel {
    
    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(spacingValue: CGFloat = 2) {
        
        // MARK: - Check if there's any text
        guard let textString = text else { return }
        
        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString(string: textString)
        
        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()
        
        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue
        
        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
            ))
        
        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }
    
}


extension String {
    
    /// Apply strike font on text
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
}

// An attributed string extension to achieve colors on text.
extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}

extension String {
    func convertToTimeInterval() -> TimeInterval {
        guard self != "" else {
            return 0
        }
        
        var interval:Double = 0
        
        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
    }
}

extension Date
{
    //"2021-02-24 14:52:56"
    func toString(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}

extension String
{
    init(hours: Int, minutes: Int, seconds: Int) {
        self = String(hours) + "h " + String(minutes) + "m " + String(seconds) + "s"
    }
    
    init(minutes: Int, seconds: Int)
    {
        self = String(minutes) + ":" + String(seconds)
    }
}


// Safari services
extension UIViewController
{
    func openSafari(open linkString: String)
    {
        if let url = URL(string: linkString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let safariViewController = SFSafariViewController(url: url, configuration: config)
            present(safariViewController, animated: true)
        }
    }
    
    func openSocialLink(for social: SocialMedias, username: String)
    {
        if let socialMediaURL = URL(string: social.rawValue + username)
        {
            if UIApplication.shared.canOpenURL(socialMediaURL)
            {
                UIApplication.shared.open(socialMediaURL, options: [:], completionHandler: nil)
            }
            else
            {
                openSafari(open: (social == .facebook ? "https://facebook.com/" : "http://instagram.com/") + username)
            }
        }
    }
}

extension String{
    func replaceWhiteSpaces() -> String{
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? self
        return encodedString.replace(string: " ", replacement: "%20")
    }
}

enum SocialMedias: String
{
    case facebook = "fb://profile?id="
    case instagram = "instagram://user?username="
}


