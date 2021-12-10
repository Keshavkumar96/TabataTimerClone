//
//  TTTimerRunView.swift
//  TabattaTimer
//
//  Created by apple on 05/02/21.
//

import UIKit

protocol TTPauseButtonActionDelegate: NSObjectProtocol {
    func playPauseButtonAction()
}

/// View to run the timer when the timer starts. Shows the running time, set name and play pause button
/// Used in TTHomeViewController

class TTTimerRunView: UIView {

    // MARK: - PROPERITIES
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.numberOfLines = 0
       return label
    }()
    
    lazy var timerLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 90)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private var viewConstraints = [NSLayoutConstraint]()
    
    weak var delegate: TTPauseButtonActionDelegate?
  
    var playPauseButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        return button
    }()
    
    // MARK: - INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTimerRunView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - HELPER METHODS
    @objc func playPauseButtonAction(sender: UIButton) {
        delegate?.playPauseButtonAction()
    }
    
    private func configureTimerRunView() {
        backgroundColor = .systemYellow
        addSubview(titleLabel)
        addSubview(timerLabel)
        addSubview(playPauseButton)
        viewConstraints.append(contentsOf: setupTitleConstraints())
        viewConstraints.append(contentsOf: setupTimerConstraints())
        viewConstraints.append(contentsOf: setupPlayPauseButtonConstraints())
        NSLayoutConstraint.activate(viewConstraints)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonAction(sender:)), for: .touchUpInside)
    }
    
    
    func setupTitleConstraints() -> [NSLayoutConstraint] {
        [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        ]
    }
    
    private func setupTimerConstraints() -> [NSLayoutConstraint] {
       [
            timerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        ]
    }
    
    private func setupPlayPauseButtonConstraints() -> [NSLayoutConstraint] {
       [
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            playPauseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ]
    }
}
