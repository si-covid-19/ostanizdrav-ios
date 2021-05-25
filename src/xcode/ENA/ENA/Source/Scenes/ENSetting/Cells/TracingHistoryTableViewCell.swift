//
// 🦠 Corona-Warn-App
//

import UIKit

class TracingHistoryTableViewCell: UITableViewCell {
	
	private var line: SeperatorLineLayer!
	private var titleLabel: ENALabel!
	private var subtitleLabel: ENALabel!
	private var circleView: CircularProgressView!
	private var historyLabel: ENALabel!

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		// self
		selectionStyle = .none
		contentView.backgroundColor = .enaColor(for: .background)
		// titleLabel
		titleLabel = ENALabel()
		titleLabel.style = .title2
		titleLabel.numberOfLines = 0
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(titleLabel)
		// subtitleLabel
		subtitleLabel = ENALabel()
		subtitleLabel.style = .subheadline
		subtitleLabel.numberOfLines = 0
		subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(subtitleLabel)
		// historyLabel
		historyLabel = ENALabel()
		historyLabel.style = .footnote
		historyLabel.numberOfLines = 0
		historyLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(historyLabel)
		// circleView
		circleView = CircularProgressView()
		circleView.maxValue = 14
		circleView.minValue = 0
		circleView.lineWidth = 5
		circleView.fontSize = 13
		circleView.progressBarColor = .enaColor(for: .tint)
		circleView.circleColor = .enaColor(for: .hairline)
		circleView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(circleView)
		// line
		line = SeperatorLineLayer()
		contentView.layer.insertSublayer(line, at: 0)
		// activate constrinats
		NSLayoutConstraint.activate([
			// titleLabel
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
			// subtitleLabel
			subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
			subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
			// historyLabel
			historyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16 + 52 + 16),
			historyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			historyLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
			historyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
			// circleView
			circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			circleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
			historyLabel.topAnchor.constraint(greaterThanOrEqualTo: historyLabel.topAnchor, constant: 8),
			circleView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
			circleView.centerYAnchor.constraint(equalTo: historyLabel.centerYAnchor),
			circleView.widthAnchor.constraint(equalToConstant: 52),
			circleView.heightAnchor.constraint(equalToConstant: 52)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let y = line.lineWidth / 2
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: y))
		path.addLine(to: CGPoint(x: contentView.bounds.width, y: y))
		line.path = path.cgPath
	}
	
	func configure(
		progress: CGFloat,
		title: String,
		subtitle: String,
		text: String,
		colorConfigurationTuple: (UIColor, UIColor)
	) {
		titleLabel?.text = title
		subtitleLabel?.text = subtitle
		if circleView.progressBarColor != colorConfigurationTuple.0 {
			circleView.progressBarColor = colorConfigurationTuple.0
		}
		if circleView.circleColor != colorConfigurationTuple.1 {
			circleView.circleColor = colorConfigurationTuple.1
		}
		historyLabel.text = text
		circleView.progress = progress
	}
}
