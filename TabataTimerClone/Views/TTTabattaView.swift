//
//  TTTabattaView.swift
//  TabattaTimer
//
//  Created by apple on 05/02/21.
//

import UIKit

/// View to show cyles and tabatta count
/// Used in TTHomeViewController

class TTTabattaView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 75)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private var viewConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTabattaView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabattaView() {
        self.backgroundColor = .white
        addSubview(titleLabel)
        addSubview(timerLabel)
        viewConstraints.append(contentsOf: setupTitleConstraints())
        viewConstraints.append(contentsOf: setupTimerConstraints())
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func setupTitleConstraints() -> [NSLayoutConstraint] {
        [
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
    }
    
    private func setupTimerConstraints() -> [NSLayoutConstraint] {
        [
            timerLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
    }
    
}
