//
// 🦠 Corona-Warn-App
//

import UIKit

class TanInputView: UIControl, UIKeyInput {

	// MARK: - Init

	init(
		frame: CGRect,
		viewModel: TanInputViewModel
	) {
		self.viewModel = viewModel
		super.init(frame: frame)

		setup()
		setupAccessibility()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Overrides

	override var canBecomeFirstResponder: Bool {
		true
	}

	// MARK: - Protocol UIKeyInput

	var hasText: Bool {
		return !viewModel.text.isEmpty
	}

	func insertText(_ text: String) {
		guard text != "\n" else {
			viewModel.submitTan()
			return
		}

		for character in text.trimmingCharacters(in: .whitespacesAndNewlines).map({ $0.uppercased() }) {
			guard !viewModel.isNumberOfDigitsReached && !viewModel.isInputBlocked else {
				return
			}

			let label = inputLabels[viewModel.text.count]
			// updates a single boxed label
			label.text = "\(character)"
			label.isValid = character.rangeOfCharacter(from: characterSet) != nil
			viewModel.isInputBlocked = !label.isValid
			viewModel.addCharacter(character)
		}
	}

	func deleteBackward() {
		guard !viewModel.text.isEmpty else {
				return
			}
		viewModel.isInputBlocked = false
		viewModel.deleteLastCharacter()
		inputLabels[viewModel.text.count].clear()
	}

	// MARK: - Private

	private let viewModel: TanInputViewModel
	private let allowedCharacters: String = "23456789ABCDEFGHJKMNPQRSTUVWXYZ"
	private let textColor = UIColor.enaColor(for: .textPrimary1)
	private let validColor = UIColor.enaColor(for: .textSemanticGray)
	private let invalidColor = UIColor.enaColor(for: .textSemanticRed)
	private let boxColor = UIColor.enaColor(for: .separator)
	private let spacing: CGFloat = 3.0
	private let verticalSpacing: CGFloat = 8.0
	private let cornerRadius: CGFloat = 4.0
	private let boxInsets = UIEdgeInsets(top: 10, left: 1, bottom: 10, right: 1)
	private let verticalBoxInsets = UIEdgeInsets(top: 13, left: 8, bottom: 13, right: 8)
	private let font: UIFont = UIFont.enaFont(for: .title2)

	private var stackView: UIStackView!
	private var boxWidthConstraint: NSLayoutConstraint!
	private var boxHeightConstraint: NSLayoutConstraint!

	private var stackViews: [UIStackView] { stackView.arrangedSubviews.compactMap({ $0 as? UIStackView }) }
	private var labels: [UILabel] { stackViews.flatMap({ $0.arrangedSubviews }).compactMap({ $0 as? UILabel }) }
	private var inputLabels: [ENATanInputLabel] { labels.compactMap({ $0 as? ENATanInputLabel }) }
	private var numberOfDigits: Int { viewModel.digitGroups.reduce(0) { $0 + $1 } }

	private lazy var characterSet: CharacterSet = CharacterSet(charactersIn: self.allowedCharacters.uppercased())

	private func setup() {
		stackView = UIStackView()

		stackView.isUserInteractionEnabled = false
		stackView.alignment = .fill

		// Enfore left-to-right semantics for RTL languages such as Arabic.
		stackView.semanticContentAttribute = .forceLeftToRight

		// Generate character groups
		for (index, numberOfDigitsInGroup) in viewModel.digitGroups.enumerated() {
			let groupView = createGroupStackView(count: numberOfDigitsInGroup, hasDash: index < viewModel.digitGroups.count - 1)
			stackView.addArrangedSubview(groupView)
		}

		// Constrain group heights
		if let firstStackView = stackViews.first {
			stackViews[1...].forEach { $0.heightAnchor.constraint(equalTo: firstStackView.heightAnchor).isActive = true }
		}

		// Constrain character labels
		if let firstLabel = inputLabels.first {
			boxWidthConstraint = firstLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
			boxHeightConstraint = firstLabel.heightAnchor.constraint(equalToConstant: 0)
			inputLabels[1...].forEach {
				NSLayoutConstraint.activate([
					$0.widthAnchor.constraint(equalTo: firstLabel.widthAnchor),
					$0.heightAnchor.constraint(equalTo: firstLabel.heightAnchor)
				])
			}
		}

		addSubview(stackView)
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

		UIView.translatesAutoresizingMaskIntoConstraints(for: [stackView] + stackViews + labels, to: false)
		updateAxis(.horizontal)
		addTarget(self, action: #selector(becomeFirstResponder), for: .touchUpInside)
	}

	private func setupAccessibility() {
		labels.forEach { label in
			label.isAccessibilityElement = false
		}

		inputLabels.enumerated().forEach { index, label in
			label.isAccessibilityElement = true
			label.accessibilityTraits = .updatesFrequently
			label.accessibilityHint = String(format: AppStrings.ENATanInput.characterIndex, index + 1, numberOfDigits)
		}
	}

	private func createGroupStackView(count: Int, hasDash: Bool) -> UIStackView {
		let stackView = UIStackView()

		stackView.spacing = spacing
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fill

		// Enfore left-to-right semantics for RTL languages such as Arabic.
		stackView.semanticContentAttribute = .forceLeftToRight

		for _ in 0..<count { stackView.addArrangedSubview(createLabel()) }
		if hasDash { stackView.addArrangedSubview(createDash()) }

		return stackView
	}

	private func createLabel() -> ENATanInputLabel {
		let label = ENATanInputLabel(validColor: validColor, invalidColor: invalidColor)
		label.textColor = textColor

		label.clipsToBounds = true
		label.backgroundColor = boxColor
		label.layer.cornerRadius = cornerRadius

		label.font = font
		label.adjustsFontForContentSizeCategory = true

		label.textAlignment = .center
		label.lineBreakMode = .byClipping

		return label
	}

	private func createDash() -> UILabel {
		let label = UILabel()

		label.font = font
		label.adjustsFontForContentSizeCategory = true

		label.textColor = validColor
		label.textAlignment = .center
		label.text = "-"

		return label
	}

	private func updateAxis(_ axis: NSLayoutConstraint.Axis) {
		stackView.axis = axis

		let insets: UIEdgeInsets

		if axis == .horizontal {
			stackView.spacing = spacing
			stackView.distribution = .fill
			insets = boxInsets
		} else {
			stackView.spacing = verticalSpacing
			stackView.distribution = .fillEqually
			insets = verticalBoxInsets
		}

		inputLabels.forEach { $0.layoutMargins = insets }

		updateBoxSize()
	}

	private func updateBoxSize() {
		let label = UILabel()
		label.adjustsFontForContentSizeCategory = true
		label.font = font
		label.text = "W" // Largest reference character

		let size = label.intrinsicContentSize
		let insets = stackView.axis == .horizontal ? boxInsets : verticalBoxInsets

		boxWidthConstraint.constant = size.width + insets.left + insets.right
		boxHeightConstraint.constant = size.height + insets.top + insets.bottom

		boxWidthConstraint.isActive = true
		boxHeightConstraint.isActive = true
	}

}
