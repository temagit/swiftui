////
////  SwiftUIView.swift
////  SwiftUI+PhoneNumberKit
////
////  Created by Tema.Tian on 2020/6/8.
////  Copyright © 2020 Tema.Tian. All rights reserved.
////
//
//import SwiftUI
//import PhoneNumberKit
//
//struct SwiftUIView: View {
//  @State private var phoneNumber = ""
//
//  var body: some View {
//    PhoneTextFieldWrapper(text: self.$phoneNumber, size: 17, color: .white, prefix: true, placeholder: true, placeholderColor: .white)
//  }
//}
//
//struct PhoneTextFieldWrapper : UIViewRepresentable {
//  @Binding var text : String
//  private let size : CGFloat?
//  private let color : UIColor?
//  private let prefix : Bool?
//  private let placeholder : Bool?
//  private let flag : Bool?
//  private let placeholderColor : UIColor?
//
//  init(text : Binding<String>,
//       size : CGFloat? = 18,
//       color : UIColor? = .black,
//       prefix : Bool? = false,
//       placeholder : Bool? = false,
//       flag : Bool? = true,
//       placeholderColor : UIColor? = nil) {
//    self._text = text
//    self.size = size
//    self.color = color
//    self.prefix = prefix
//    self.placeholder = placeholder
//    self.flag = flag
//    self.placeholderColor = placeholderColor
//  }
//
//  func makeUIView(context: Context) -> PhoneTextField {
//    let textField = PhoneTextField(text: self.$text)
//    textField.withPrefix = prefix!
//    textField.withExamplePlaceholder = placeholder!
//    textField.font = UIFont.systemFont(ofSize: size!)
//    textField.withFlag = flag!
//    textField.textColor = color
//    textField.text! = text
//    textField.placeholderColor = placeholderColor
//    return textField
//  }
//
//  func updateUIView(_ uiView: PhoneTextField, context: Context) {
//  }
//}
//
//
//#if canImport(UIKit)
//
//import Foundation
//import UIKit
//
///// Custom text field that formats phone numbers
//open class PhoneTextField: UITextField, UITextFieldDelegate {
//  @Binding var textMessage : String
//  public let phoneNumberKit: PhoneNumberKit
//  public lazy var flagButton = UIButton()
//  
//  
//  /// Override setText so number will be automatically formatted when setting text by code
//  open override var text: String? {
//    set {
//      if isPartialFormatterEnabled, let newValue = newValue {
//        let formattedNumber = partialFormatter.formatPartial(newValue)
//        super.text = formattedNumber
//      } else {
//        super.text = newValue
//      }
//      NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
//      self.textMessage = super.text ?? ""
//    }
//    get {
//      return super.text
//    }
//  }
//
//  /// allows text to be set without formatting
//  open func setTextUnformatted(newValue: String?) {
//    super.text = newValue
//  }
//
//  private lazy var _defaultRegion: String = "US"
//
//  /// Override region to set a custom region. Automatically uses the default region code.
//  open var defaultRegion: String {
//    get {
//      return self._defaultRegion
//    }
//    @available(
//    *,
//    deprecated,
//    message: """
//    The setter of defaultRegion is deprecated,
//    please override defaultRegion in a subclass instead.
//    """
//    )
//    set {}
//  }
//
//  public var placeholderColor : UIColor? = .lightGray {
//    didSet {
//      self.updatePlaceholder()
//    }
//  }
//
//  public var withPrefix: Bool = true {
//    didSet {
//      //self.partialFormatter.withPrefix = self.withPrefix
//      if self.withPrefix == false {
//        self.keyboardType = .numberPad
//      } else {
//        self.keyboardType = .phonePad
//      }
//      if self.withExamplePlaceholder {
//        self.updatePlaceholder()
//      }
//    }
//  }
//
//  public var withFlag: Bool = false {
//    didSet {
//      leftView = self.withFlag ? self.flagButton : nil
//      leftViewMode = self.withFlag ? .always : .never
//      self.updateFlag()
//    }
//  }
//
//  public var withExamplePlaceholder: Bool = false {
//    didSet {
//      if self.withExamplePlaceholder {
//        self.updatePlaceholder()
//      } else {
//        attributedPlaceholder = nil
//      }
//    }
//  }
//
//  //    private var _withDefaultPickerUI: Bool = false {
//  //        didSet {
//  //            if #available(iOS 11.0, *), flagButton.actions(forTarget: self, forControlEvent: .touchUpInside) == nil {
//  //                flagButton.addTarget(self, action: #selector(didPressFlagButton), for: .touchUpInside)
//  //            }
//  //        }
//  //    }
//  //
//  //    @available(iOS 11.0, *)
//  //    public var withDefaultPickerUI: Bool {
//  //        get { _withDefaultPickerUI }
//  //        set { _withDefaultPickerUI = newValue }
//  //    }
//  public var isPartialFormatterEnabled = true
//
//  public var maxDigits: Int? {
//    didSet {
//      self.partialFormatter.maxDigits = self.maxDigits
//    }
//  }
//
//  public private(set) lazy var partialFormatter: PartialFormatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: defaultRegion, withPrefix: withPrefix)
//
//  let nonNumericSet: NSCharacterSet = {
//    var mutableSet = NSMutableCharacterSet.decimalDigit().inverted
//    mutableSet.remove(charactersIn: PhoneNumberConstants.plusChars)
//    mutableSet.remove(charactersIn: PhoneNumberConstants.pausesAndWaitsChars)
//    mutableSet.remove(charactersIn: PhoneNumberConstants.operatorChars)
//    return mutableSet as NSCharacterSet
//  }()
//
//  private weak var _delegate: UITextFieldDelegate?
//
//  open override var delegate: UITextFieldDelegate? {
//    get {
//      return self._delegate
//    }
//    set {
//      self._delegate = newValue
//    }
//  }
//
//  // MARK: Status
//  public var currentRegion: String {
//    return self.partialFormatter.currentRegion
//  }
//
//  public var nationalNumber: String {
//    let rawNumber = self.text ?? String()
//    return self.partialFormatter.nationalNumber(from: rawNumber)
//  }
//
//  public var isValidNumber: Bool {
//    let rawNumber = self.text ?? String()
//    do {
//      _ = try phoneNumberKit.parse(rawNumber, withRegion: currentRegion)
//      return true
//    } catch {
//      return false
//    }
//  }
//
//  open override func layoutSubviews() {
//    if self.withFlag { // update the width of the flagButton automatically, iOS <13 doesn't handle this for you
//      let width = self.flagButton.systemLayoutSizeFitting(bounds.size).width
//      self.flagButton.frame.size.width = width
//    }
//    super.layoutSubviews()
//  }
//
//  // MARK: Lifecycle
//  /**
//   Init with a phone number kit instance. Because a PhoneNumberKit initialization is expensive,
//   you can pass a pre-initialized instance to avoid incurring perf penalties.
//   - parameter phoneNumberKit: A PhoneNumberKit instance to be used by the text field.
//   - returns: UITextfield
//   */
//  public convenience init(text textMessage: Binding<String>, withPhoneNumberKit phoneNumberKit: PhoneNumberKit = PhoneNumberKit()) {
//    self.init(text: textMessage, frame: .zero, phoneNumberKit: phoneNumberKit)
//    self.setup()
//  }
//
//  /**
//   Init with frame and phone number kit instance.
//   - parameter frame: UITextfield frame
//   - parameter phoneNumberKit: A PhoneNumberKit instance to be used by the text field.
//   - returns: UITextfield
//   */
//  public init(text textMessage: Binding<String>, frame: CGRect, phoneNumberKit: PhoneNumberKit) {
//    self.phoneNumberKit = phoneNumberKit
//    self._textMessage = textMessage
//    super.init(frame: frame)
//    self.setup()
//  }
//
//  /**
//   Init with frame
//   - parameter frame: UITextfield F
//   - returns: UITextfield
//   */
//  //    public override init(frame: CGRect) {
//  //        self.phoneNumberKit = PhoneNumberKit()
//  //        super.init(frame: frame)
//  //        self.setup()
//  //    }
//  /**
//   Init with coder
//   - parameter aDecoder: decoder
//   - returns: UITextfield
//   */
//  public required init(text textMessage: Binding<String>,coder aDecoder: NSCoder) {
//    self.phoneNumberKit = PhoneNumberKit()
//    self._textMessage = textMessage
//    super.init(coder: aDecoder)!
//    self.setup()
//  }
//
//  public required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  func setup() {
//    self.autocorrectionType = .no
//    self.keyboardType = .phonePad
//    super.delegate = self
//  }
//
//  func internationalPrefix(for countryCode: String) -> String? {
//    guard let countryCode = phoneNumberKit.countryCode(for: currentRegion)?.description else { return nil }
//    return "+" + countryCode
//  }
//
//  open func updateFlag() {
//    guard self.withFlag else { return }
//    let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
//
//    let flag = self.currentRegion
//      .uppercased()
//      .unicodeScalars
//      .compactMap { UnicodeScalar(flagBase + $0.value)?.description }
//      .joined()
//
//    self.flagButton.setTitle(flag + " ", for: .normal)
//    let fontSize = (font ?? UIFont.preferredFont(forTextStyle: .body)).pointSize
//    self.flagButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
//  }
//
//  open func updatePlaceholder() {
//    guard self.withExamplePlaceholder else { return }
//    if isEditing, !(self.text ?? "").isEmpty { return } // No need to update a placeholder while the placeholder isn't showing
//    let format: PhoneNumberFormat
//    if self.currentRegion == "RU" {
//      format = self.withPrefix ? PhoneNumberFormat.national : .international
//    } else {
//      format = self.withPrefix ? PhoneNumberFormat.international : .national
//    }
//
//    let example = self.phoneNumberKit.getFormattedExampleNumber(forCountry: self.currentRegion, withFormat: format, withPrefix: self.withPrefix) ?? "12345678"
//
//    let font = self.font ?? UIFont.preferredFont(forTextStyle: .body)
//    let ph = NSMutableAttributedString(string: example, attributes: [.font: font])
//    #if compiler(>=5.1)
//    if #available(iOS 13.0, *), self.withPrefix {
//      // because the textfield will automatically handle insert & removal of the international prefix we make the
//      // prefix darker to indicate non default behaviour to users, this behaviour currently only happens on iOS 13
//      // and above just because that is where we have access to label colors
//      let firstSpaceIndex = example.firstIndex(where: { $0 == " " }) ?? example.startIndex
//      // UIColor.secondaryLabel UIColor.tertiaryLabel
//      ph.addAttribute(.foregroundColor, value: self.placeholderColor!, range: NSRange(..<firstSpaceIndex, in: example))
//      ph.addAttribute(.foregroundColor, value: self.placeholderColor!, range: NSRange(firstSpaceIndex..., in: example))
//    }
//    #endif
//    self.attributedPlaceholder = ph
//  }
//
//  //    @available(iOS 11.0, *)
//  //    @objc func didPressFlagButton() {
//  //        guard withDefaultPickerUI else { return }
//  //        let vc = CountryCodePickerViewController(phoneNumberKit: phoneNumberKit)
//  //        vc.delegate = self
//  //        if let nav = containingViewController?.navigationController, !PhoneNumberKit.CountryCodePicker.forceModalPresentation {
//  //            nav.pushViewController(vc, animated: true)
//  //        } else {
//  //            let nav = UINavigationController(rootViewController: vc)
//  //            containingViewController?.present(nav, animated: true)
//  //        }
//  //    }
//  /// containingViewController looks at the responder chain to find the view controller nearest to itself
//  var containingViewController: UIViewController? {
//    var responder: UIResponder? = self
//    while !(responder is UIViewController) && responder != nil {
//      responder = responder?.next
//    }
//    return (responder as? UIViewController)
//  }
//
//
//  // MARK: Phone number formatting
//  /**
//   *  To keep the cursor position, we find the character immediately after the cursor and count the number of times it repeats in the remaining string as this will remain constant in every kind of editing.
//   */
//
//  internal struct CursorPosition {
//    let numberAfterCursor: String
//    let repetitionCountFromEnd: Int
//  }
//
//  internal func extractCursorPosition() -> CursorPosition? {
//    var repetitionCountFromEnd = 0
//    // Check that there is text in the UITextField
//    guard let text = text, let selectedTextRange = selectedTextRange else {
//      return nil
//    }
//    let textAsNSString = text as NSString
//    let cursorEnd = offset(from: beginningOfDocument, to: selectedTextRange.end)
//    // Look for the next valid number after the cursor, when found return a CursorPosition struct
//    for i in cursorEnd..<textAsNSString.length {
//      let cursorRange = NSRange(location: i, length: 1)
//      let candidateNumberAfterCursor: NSString = textAsNSString.substring(with: cursorRange) as NSString
//      if candidateNumberAfterCursor.rangeOfCharacter(from: self.nonNumericSet as CharacterSet).location == NSNotFound {
//        for j in cursorRange.location..<textAsNSString.length {
//          let candidateCharacter = textAsNSString.substring(with: NSRange(location: j, length: 1))
//          if candidateCharacter == candidateNumberAfterCursor as String {
//            repetitionCountFromEnd += 1
//          }
//        }
//        return CursorPosition(numberAfterCursor: candidateNumberAfterCursor as String, repetitionCountFromEnd: repetitionCountFromEnd)
//      }
//    }
//    return nil
//  }
//
//  // Finds position of previous cursor in new formatted text
//  internal func selectionRangeForNumberReplacement(textField: UITextField, formattedText: String) -> NSRange? {
//    let textAsNSString = formattedText as NSString
//    var countFromEnd = 0
//    guard let cursorPosition = extractCursorPosition() else {
//      return nil
//    }
//
//    for i in stride(from: textAsNSString.length - 1, through: 0, by: -1) {
//      let candidateRange = NSRange(location: i, length: 1)
//      let candidateCharacter = textAsNSString.substring(with: candidateRange)
//      if candidateCharacter == cursorPosition.numberAfterCursor {
//        countFromEnd += 1
//        if countFromEnd == cursorPosition.repetitionCountFromEnd {
//          return candidateRange
//        }
//      }
//    }
//
//    return nil
//  }
//
//  open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//    // This allows for the case when a user autocompletes a phone number:
//    if range == NSRange(location: 0, length: 0), string == " " {
//      return true
//    }
//
//    guard let text = text else {
//      return false
//    }
//
//    // allow delegate to intervene
//    guard self._delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true else {
//      return false
//    }
//    guard self.isPartialFormatterEnabled else {
//      return true
//    }
//
//    let textAsNSString = text as NSString
//    let changedRange = textAsNSString.substring(with: range) as NSString
//    let modifiedTextField = textAsNSString.replacingCharacters(in: range, with: string)
//
//    let filteredCharacters = modifiedTextField.filter {
//      String($0).rangeOfCharacter(from: (textField as! PhoneTextField).nonNumericSet as CharacterSet) == nil
//    }
//    let rawNumberString = String(filteredCharacters)
//
//    let formattedNationalNumber = self.partialFormatter.formatPartial(rawNumberString as String)
//    var selectedTextRange: NSRange?
//
//    let nonNumericRange = (changedRange.rangeOfCharacter(from: self.nonNumericSet as CharacterSet).location != NSNotFound)
//    if range.length == 1, string.isEmpty, nonNumericRange {
//      selectedTextRange = self.selectionRangeForNumberReplacement(textField: textField, formattedText: modifiedTextField)
//      textField.text = modifiedTextField
//    } else {
//      selectedTextRange = self.selectionRangeForNumberReplacement(textField: textField, formattedText: formattedNationalNumber)
//      textField.text = formattedNationalNumber
//    }
//    sendActions(for: .editingChanged)
//    if let selectedTextRange = selectedTextRange, let selectionRangePosition = textField.position(from: beginningOfDocument, offset: selectedTextRange.location) {
//      let selectionRange = textField.textRange(from: selectionRangePosition, to: selectionRangePosition)
//      textField.selectedTextRange = selectionRange
//    }
//
//    // we change the default region to be the one most recently typed
//    self._defaultRegion = self.currentRegion
//    self.partialFormatter.defaultRegion = self.currentRegion
//    self.updateFlag()
//    self.updatePlaceholder()
//
//    return false
//  }
//
//  // MARK: UITextfield Delegate
//  open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//    return self._delegate?.textFieldShouldBeginEditing?(textField) ?? true
//  }
//
//  open func textFieldDidBeginEditing(_ textField: UITextField) {
//    if self.withExamplePlaceholder, self.withPrefix, let countryCode = phoneNumberKit.countryCode(for: currentRegion)?.description, (text ?? "").isEmpty {
//      text = "+" + countryCode + " "
//    }
//    self._delegate?.textFieldDidBeginEditing?(textField)
//
//  }
//
//  open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//    return self._delegate?.textFieldShouldEndEditing?(textField) ?? true
//  }
//
//  open func textFieldDidEndEditing(_ textField: UITextField) {
//    if self.withExamplePlaceholder, self.withPrefix, let countryCode = phoneNumberKit.countryCode(for: currentRegion)?.description,
//      let text = textField.text,
//      text == internationalPrefix(for: countryCode) {
//      textField.text = ""
//      sendActions(for: .editingChanged)
//      self.updateFlag()
//      self.updatePlaceholder()
//    }
//    self._delegate?.textFieldDidEndEditing?(textField)
//
//  }
//
//  open func textFieldShouldClear(_ textField: UITextField) -> Bool {
//    return self._delegate?.textFieldShouldClear?(textField) ?? true
//  }
//
//  open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    return self._delegate?.textFieldShouldReturn?(textField) ?? true
//  }
//}
//
////@available(iOS 11.0, *)
////extension PhoneTextField: CountryCodePickerDelegate {
////
////    func countryCodePickerViewControllerDidPickCountry(_ country: CountryCodePickerViewController.Country) {
////        text = isEditing ? "+" + country.prefix : ""
////        _defaultRegion = country.code
////        partialFormatter.defaultRegion = country.code
////        updateFlag()
////        updatePlaceholder()
////
////        if let nav = containingViewController?.navigationController {
////            nav.popViewController(animated: true)
////        } else {
////            containingViewController?.dismiss(animated: true)
////        }
////    }
////}
//#endif
//
//
//struct PhoneNumberConstants {
//  static let defaultCountry = "US"
//  static let defaultExtnPrefix = " ext. "
//  static let longPhoneNumber = "999999999999999"
//  static let minLengthForNSN = 2
//  static let maxInputStringLength = 250
//  static let maxLengthCountryCode = 3
//  static let maxLengthForNSN = 16
//  static let nonBreakingSpace = "\u{00a0}"
//  static let plusChars = "+＋"
//  static let pausesAndWaitsChars = ",;"
//  static let operatorChars = "*#"
//  static let validDigitsString = "0-9０-９٠-٩۰-۹"
//  static let digitPlaceholder = "\u{2008}"
//  static let separatorBeforeNationalNumber = " "
//}
