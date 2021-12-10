//
//  TTTimerSetup.swift
//  TabattaTimer
//
//  Created by apple on 05/02/21.
//

import UIKit

/// View to show the workout set name and timer count.
/// Used in TTHomeViewController

class TTTimerView: UIView {

    // MARK: - PROPERITIES
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy var timerCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private var viewConstraints = [NSLayoutConstraint]()
    
    // MARK: - INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTimerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - HELPER METHODS 
    private func configureTimerView() {
        self.backgroundColor = .red
        addSubview(titleLabel)
        addSubview(timerCountLabel)
        viewConstraints.append(contentsOf: setupTimerLabelConstraints())
        viewConstraints.append(contentsOf: setupTimerCountraints())
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func setupTimerLabelConstraints() -> [NSLayoutConstraint] {
        [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)
        ]
    }
    
    private func setupTimerCountraints() -> [NSLayoutConstraint] {
        [
            timerCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            timerCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            timerCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)
        ]
    }
    
}
