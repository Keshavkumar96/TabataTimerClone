//
//  TTTimerSaveCell.swift
//  TabattaTimer
//
//  Created by apple on 05/02/21.
//

import UIKit

protocol TTSaveButtonActionDelegate: NSObjectProtocol {
    func saveAction()
}

class TTTimerSaveCell: UITableViewCell {
    
    static let reuseId = "TTTimerSaveCell"
    weak var saveDelegate: TTSaveButtonActionDelegate?
    
    // MARK: - PROPERITIES
    private lazy var saveButton: UIButton = {
        let save = UIButton()
        save.setTitle("SAVE", for: .normal)
        save.translatesAutoresizingMaskIntoConstraints = false
        save.titleLabel?.textAlignment = .center
        save.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        save.backgroundColor = .blue
        save.layer.cornerRadius = 24
        return save
    }()
    
    private var viewConstraints = [NSLayoutConstraint]()
    
    // MARK: - INITIALIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTimerSaveCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - METHODS
    private func configureTimerSaveCell() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonAction(sender:)), for: .touchUpInside)
        viewConstraints.append(contentsOf: setupSaveButtonConstraints())
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    @objc func saveButtonAction(sender: UIButton) {
        saveDelegate?.saveAction()
    }
    
    private func setupSaveButtonConstraints() -> [NSLayoutConstraint] {
        [
            saveButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ]
    }
}
