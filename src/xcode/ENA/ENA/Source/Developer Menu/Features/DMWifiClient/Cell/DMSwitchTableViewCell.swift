//
// 🦠 Corona-Warn-App
//

#if !RELEASE

import UIKit

class DMSwitchTableViewCell: UITableViewCell {

	// MARK: - Init

	// MARK: - Overrides

	override func awakeFromNib() {
		super.awakeFromNib()
		toggleSwitch.addTarget(self, action: #selector(toggleHit), for: .valueChanged)
	}

	// MARK: - Public

	// MARK: - Internal

	func configure(cellViewModel: DMSwitchCellViewModel) {
		infoLabel.text = cellViewModel.labelText
		toggleSwitch.isOn = cellViewModel.isOn()
		self.cellViewModel = cellViewModel
	}

	// MARK: - Private

	@IBOutlet private weak var infoLabel: UILabel!
	@IBOutlet private weak var toggleSwitch: UISwitch!

	private var cellViewModel: DMSwitchCellViewModel?

	@objc
	private func toggleHit() {
		cellViewModel?.toggle()
		setSelected(false, animated: true)
	}

}

#endif
