//
//  TTTimerSettingCell.swift
//  TabattaTimer
//
//  Created by apple on 04/02/21.
//

import UIKit

protocol TTStepperTimerDelegate: NSObjectProtocol {
    func updateStepper(stepperValue: Double, cell: UITableViewCell)
}

/// Cell used to show update the timer for each work out set
/// Used in TTTimerViewController

class TTTimerSettingCell: UITableViewCell {
    static let reuseId = "TTTimerSettingCell"
    
    // MARK: - PROPERITIES
    weak var stepperDelegate: TTStepperTimerDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
   lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = TTUtilities.timeString(0)
        label.textColor = .black
        return label
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.isUserInteractionEnabled = true
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.backgroundColor = .systemYellow
        stackView.layer.cornerRadius = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stepperForTimer: UIStepper = {
       let stepper = UIStepper()
        stepper.value = 0
        stepper.minimumValue = 0
        stepper.isContinuous = true
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.autorepeat = true
        stepper.maximumValue = 10000
        return stepper
    }()
    
    private var viewConstraints = [NSLayoutConstraint]()
    
    // MARK: - INITIALIZER
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupContainerView()
        stepperForTimer.addTarget(self, action: #selector(stepperAction(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView() {
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(timerLabel)
        containerView.addArrangedSubview(stepperForTimer)
        contentView.addSubview(containerView)
        viewConstraints.append(contentsOf: setupContainerViewConstraints())
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    @objc func stepperAction(_ sender: UIStepper) {
        stepperDelegate?.updateStepper(stepperValue: sender.value, cell: self)
    }
    
    private func setupContainerViewConstraints() -> [NSLayoutConstraint] {
       [
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ]
    }
}
