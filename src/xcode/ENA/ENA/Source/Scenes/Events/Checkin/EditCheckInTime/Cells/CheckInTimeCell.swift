////
// 🦠 Corona-Warn-App
//

import UIKit
import OpenCombine

class CheckInTimeCell: UITableViewCell, ReuseIdentifierProviding {

	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Overrides

	override func prepareForReuse() {
		super.prepareForReuse()
		subscriptions.forEach { $0.cancel() }
		subscriptions.removeAll()
	}

	// MARK: - Internal

	func configure(_ cellModel: CheckInTimeModel) {
		typeLabel.text = cellModel.type
		typeLabel.accessibilityIdentifier = AccessibilityIdentifiers.Checkin.Details.typeLabel
		topSeparatorView.isHidden = !cellModel.hasTopSeparator
		topLayoutConstraint.constant = cellModel.hasTopSeparator ? 16.0 : 0.0
		bottomLayoutConstraint.constant = cellModel.hasTopSeparator ? 0.0 : -16.0
		cellModel.$date
			.receive(on: DispatchQueue.main.ocombine)
			.sink { _ in
				self.dateTimeLabel.text = cellModel.dateString
				self.dateTimeLabel.accessibilityLabel = cellModel.accessibilityDate
			}
			.store(in: &subscriptions)

		cellModel.$isPickerVisible
			.receive(on: DispatchQueue.main.ocombine)
			.sink { isVisible in
				self.dateTimeLabel.textColor = isVisible ? .enaColor(for: .textTint) : .enaColor(for: .textPrimary1)
			}
			.store(in: &subscriptions)
	}

	// MARK: - Private

	private let typeLabel = ENALabel(style: .headline)
	private let dateTimeLabel = ENALabel(style: .headline)
	private let topSeparatorView = UIView()
	private var topLayoutConstraint: NSLayoutConstraint!
	private var bottomLayoutConstraint: NSLayoutConstraint!
	private var subscriptions = Set<AnyCancellable>()

	private func setupView() {
		selectionStyle = .none
		backgroundColor = .enaColor(for: .cellBackground)
		contentView.backgroundColor = .enaColor(for: .cellBackground)

		typeLabel.font = .enaFont(for: .headline, weight: .regular)
		typeLabel.textColor = .enaColor(for: .textPrimary1)

		dateTimeLabel.font = .enaFont(for: .headline, weight: .semibold)
		dateTimeLabel.textColor = .enaColor(for: .textPrimary1)
		dateTimeLabel.textAlignment = .right
		dateTimeLabel.numberOfLines = 1

		// we add a placeholder text to get the cell height calculation right
		// otherwise the label is hidden, text gets updated as soon as configure with a cellViewModel gets called
		dateTimeLabel.text = "placeholder"

		let tileView = UIView()
		tileView.translatesAutoresizingMaskIntoConstraints = false
		tileView.backgroundColor = .enaColor(for: .cellBackground2)
		contentView.addSubview(tileView)

		topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
		topSeparatorView.backgroundColor = .enaColor(for: .hairline)
		tileView.addSubview(topSeparatorView)

		let stackView = AccessibleStackView(arrangedSubviews: [typeLabel, dateTimeLabel])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.spacing = 36.0
		stackView.distribution = .fill
		stackView.alignment = .center
		tileView.addSubview(stackView)

		topLayoutConstraint = stackView.topAnchor.constraint(equalTo: tileView.topAnchor, constant: 18.0)
		bottomLayoutConstraint = stackView.bottomAnchor.constraint(equalTo: tileView.bottomAnchor, constant: -18.0)
		NSLayoutConstraint.activate(
			[
				tileView.topAnchor.constraint(equalTo: contentView.topAnchor),
				tileView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
				tileView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
				tileView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),

				topSeparatorView.topAnchor.constraint(equalTo: tileView.topAnchor),
				topSeparatorView.leadingAnchor.constraint(equalTo: tileView.leadingAnchor, constant: 16.0),
				topSeparatorView.trailingAnchor.constraint(equalTo: tileView.trailingAnchor, constant: -16.0),
				topSeparatorView.heightAnchor.constraint(equalToConstant: 1.0),

				topLayoutConstraint,
				bottomLayoutConstraint,
				stackView.leadingAnchor.constraint(equalTo: tileView.leadingAnchor, constant: 16.0),
				stackView.trailingAnchor.constraint(equalTo: tileView.trailingAnchor, constant: -16.0)
			]
		)
	}

}
