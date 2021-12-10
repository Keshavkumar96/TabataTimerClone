//
//  TTTimerViewController.swift
//  TabattaTimer
//
//  Created by apple on 05/02/21.
//

import UIKit

enum SetNames: String {
    case prepare = "PREPARE"
    case work = "WORK"
    case rest = "REST"
    case cycles = "CYCLES"
    case tabatta = "TABATTA"
}

class TTHomeViewController: UIViewController {

    // MARK: - PROPERITIES
    private lazy var mainContainerView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = TTUtilities.ttCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = TTUtilities.ttCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var startStopButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("START", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.layer.cornerRadius = TTUtilities.ttCornerRadius
        return button
    }()
    
    
    private lazy var timerContainerView: UIStackView = {
       let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.spacing = 20
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.backgroundColor = .clear
       return stackview
    }()
    
    private lazy var prepareTimerView: TTTimerView = {
       let view = TTTimerView()
        view.titleLabel.text = SetNames.prepare.rawValue
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = TTUtilities.ttCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var workTimerView: TTTimerView = {
       let view = TTTimerView()
        view.titleLabel.text = SetNames.work.rawValue
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = TTUtilities.ttCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var restTimerView: TTTimerView = {
        let view = TTTimerView()
        view.titleLabel.text = SetNames.rest.rawValue
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = TTUtilities.ttCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cyclesTimer: TTTabattaView = {
        let view = TTTabattaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = SetNames.cycles.rawValue
        view.timerLabel.text = TTUtilities.countString(0)
        view.layer.cornerRadius = TTUtilities.ttCornerRadius
        return view
    }()
    
    private lazy var tabattaTimer: TTTabattaView = {
        let view = TTTabattaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = SetNames.tabatta.rawValue
        view.timerLabel.text = TTUtilities.countString(0)
        view.layer.cornerRadius = TTUtilities.ttCornerRadius
        return view
    }()
    
    private lazy var timerRunView: TTTimerRunView = {
        let view = TTTimerRunView()
        view.titleLabel.text = SetNames.prepare.rawValue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = TTUtilities.ttCornerRadius
        view.isHidden = true
        view.timerLabel.text = TTUtilities.timeString(0)
        return view
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var viewConstraints = [NSLayoutConstraint]()
    
    // MARK: - ENUMS
    enum WorkOutState {
        case prepare
        case work
        case rest
        case idle
    }
    
    enum TimerState {
        case play
        case pause
    }
    
    // MARK: - VARIABLES
    
    // Timer
    private var timer = Timer()
    
    // varibles to hold the running timings when the timer starts
    private var runningTime: Int = 0
    
    // variable to hold the cycleCount and tabatta count
    private var cyclesCount: Int = 0
    private var tabattaCount: Int = 0
    

    // enum flag to identify which set is running & update the values accordingly
    private var currentWorkOutState: WorkOutState = .idle {
        didSet {
            switch currentWorkOutState {
            case .prepare:
                runningTime = TTTimerValues.shared.prepareDurationInSec
                timerRunView.titleLabel.text = SetNames.prepare.rawValue
                timerRunView.backgroundColor = .yellow
                
            case .work:
                runningTime = TTTimerValues.shared.workDurationInSec
                timerRunView.titleLabel.text = SetNames.work.rawValue
                timerRunView.backgroundColor = .green
                
            case .rest:
                runningTime = TTTimerValues.shared.restDurationInSec
                timerRunView.titleLabel.text = SetNames.rest.rawValue
                timerRunView.backgroundColor = .red
                
            case .idle:
                currentTimerState = .play
                timer.invalidate()
                timerRunView.isHidden = true
                timerContainerView.isHidden = false
                updateValues()
                timerRunView.timerLabel.text = TTUtilities.timeString(0)
                startStopButton.setTitle("START", for: .normal)
            }
        }
    }
    
    private var currentTimerState: TimerState = .pause
    

    // MARK: - VIEWLIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupConstraints()
        initialUISetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateValues()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)
           updateAxis(forTraitCollection: traitCollection)
       }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateAxis(forTraitCollection: traitCollection)
    }
    
    // MARK: - IBACTION METHODS
    @objc func startStopButtonAction(sender: UIButton) {
        if TTTimerValues.shared.numberOfCycles == 0 || TTTimerValues.shared.numberOfTabatta == 0 {
            return
        }
        
        switch currentWorkOutState {
        case .idle: startTheTimer()
            
        default: stopTheTimer()
        }
    }
    
    @objc func settingsButtonAction(sender: UIButton) {
         let vc = TTTimerViewController()
        self.navigationController?.pushViewController(vc, animated: true) 
     }
    

}

// MARK: - CONFIGURE METHODS
extension TTHomeViewController {
   
    private func configureViews() {
        configureMainContainerView()
        configureTopContainerView()
        configureBottomContainerView()
    }
    
    private func configureMainContainerView() {
        view.addSubview(mainContainerView)
        mainContainerView.addArrangedSubview(topContainerView)
        mainContainerView.addArrangedSubview(bottomContainerView)
    }
    
    private func configureTopContainerView() {
        topContainerView.addSubview(timerContainerView)
        timerContainerView.addArrangedSubview(prepareTimerView)
        timerContainerView.addArrangedSubview(workTimerView)
        timerContainerView.addArrangedSubview(restTimerView)
        topContainerView.addSubview(timerRunView)
        timerRunView.delegate = self
    }
    
    private func configureBottomContainerView() {
        bottomContainerView.addSubview(startStopButton)
        bottomContainerView.addSubview(cyclesTimer)
        bottomContainerView.addSubview(tabattaTimer)
        bottomContainerView.addSubview(settingsButton)
        startStopButton.addTarget(self, action: #selector(startStopButtonAction(sender:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
    }
    
}

// MARK: - CONSTRAINTS SETUP -
extension TTHomeViewController {
    
    private func setupConstraints() {
        mainContainerView.pinToSuperViewSafeArea(to: view)
        viewConstraints.append(contentsOf: setupConstraintsForStartStopButton())
        viewConstraints.append(contentsOf: setupConstraintsForContainerStack())
        viewConstraints.append(contentsOf: setupConstraintsForCycleTimer())
        viewConstraints.append(contentsOf: setupConstraintsForTabattaTimer())
        viewConstraints.append(contentsOf: setupConstraintsForSettingsButton())
        viewConstraints.append(contentsOf: setupConstraintsForTimmerRunView())
        NSLayoutConstraint.activate(viewConstraints)
    }
        
    private func setupConstraintsForStartStopButton() -> [NSLayoutConstraint] {
        [
        startStopButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor, constant: 0),
        startStopButton.topAnchor.constraint(equalTo: cyclesTimer.bottomAnchor, constant: 40),
        startStopButton.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, constant: -20),
        startStopButton.heightAnchor.constraint(equalTo: bottomContainerView.heightAnchor, multiplier: 0.23)
        ]
    }
    
    
    private func setupConstraintsForContainerStack() -> [NSLayoutConstraint] {
        [
            timerContainerView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
            timerContainerView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
            timerContainerView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
            timerContainerView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10)
        ]
    }
    
   private func setupConstraintsForCycleTimer() -> [NSLayoutConstraint] {
        [
            cyclesTimer.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 20),
            cyclesTimer.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 10),
            cyclesTimer.heightAnchor.constraint(equalTo: bottomContainerView.heightAnchor, multiplier: 0.4),
            cyclesTimer.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: 0.35)
        ]
    }
    
    private func setupConstraintsForTabattaTimer() -> [NSLayoutConstraint] {
        [
            tabattaTimer.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 20),
            tabattaTimer.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -10),
            tabattaTimer.heightAnchor.constraint(equalTo: bottomContainerView.heightAnchor, multiplier: 0.4),
            
            tabattaTimer.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: 0.35)
        ]
    }
    
    private func setupConstraintsForSettingsButton() -> [NSLayoutConstraint] {
        [
        settingsButton.leadingAnchor.constraint(equalTo: cyclesTimer.trailingAnchor, constant: -5),
        settingsButton.trailingAnchor.constraint(equalTo: tabattaTimer.leadingAnchor, constant: 5),
        settingsButton.bottomAnchor.constraint(equalTo: cyclesTimer.bottomAnchor, constant: 0)
        ]
    }
    
    private func setupConstraintsForTimmerRunView() -> [NSLayoutConstraint] {
        [
            timerRunView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
            timerRunView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
            timerRunView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
            timerRunView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10)
        ]
    }
    
}

// MARK: - UI CONFIGURATION
extension TTHomeViewController {
    private func initialUISetup() {
        view.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = .black
    }

    private func updateValues() {
        updateTimeLabels()
        getTimings()
    }
    
    private func updateTimeLabels() {
        prepareTimerView.timerCountLabel.text = TTTimerValues.shared.prepareDurationSecInString
        workTimerView.timerCountLabel.text = TTTimerValues.shared.workDurationSecInString
        restTimerView.timerCountLabel.text = TTTimerValues.shared.restDurationSecInString
        cyclesTimer.timerLabel.text = TTTimerValues.shared.cyclesCountInString
        tabattaTimer.timerLabel.text = TTTimerValues.shared.tabattaCountInString
    }
    
    private func getTimings() {
        cyclesCount = TTTimerValues.shared.numberOfCycles
        tabattaCount = TTTimerValues.shared.numberOfTabatta
    }
}


// MARK: - HELPER METHODS
extension TTHomeViewController {
    
    @objc func runTimer() {
        triggerTimer(currentWorkOutState)
    }
    
    private func updateAxis(forTraitCollection traitCollection: UITraitCollection) {
        switch traitCollection.horizontalSizeClass {
          case .regular:
            mainContainerView.axis =  traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact ? .horizontal : .vertical
            
          case .compact:
            mainContainerView.axis = traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact ? .horizontal : .vertical
            
          case .unspecified:
              mainContainerView.axis = .vertical
            
          @unknown default:
             mainContainerView.axis = .vertical
          }
      }
    
    // Will be called everytime when we tap on start button.
    private func startTheTimer() {
        currentTimerState = .pause
        toggleTimer()
        currentWorkOutState = .prepare
        timerRunView.isHidden = false
        timerContainerView.isHidden = true
        startStopButton.setTitle("STOP", for: .normal)
    }
    
    // will be called everytime when we tap on stop button.
    private func stopTheTimer() {
        currentWorkOutState = .idle
    }
    
    // will be called everytime when we tap on play/pause button.
    private func toggleTimer() {
        
        switch currentTimerState {
            
        case .play:
            timerRunView.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            currentTimerState = .pause
            timer.invalidate()
          
        case .pause:
            timerRunView.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            currentTimerState = .play
            
        }

    }
        
    
    private func triggerTimer(_ state: WorkOutState) {
        
        if runningTime >= 0 {
            timerRunView.timerLabel.text = TTUtilities.timeString(runningTime)
            runningTime -= 1
        }
        
        switch state {
        case .prepare:
            if runningTime < 0 {
                currentWorkOutState = .work
            }
            
        case .work:
            if runningTime < 0 {
                currentWorkOutState = .rest
            }
            
        case .rest:
            if runningTime < 0 {
                cyclesCount -= 1
                updateTheTimer()
            }
            
        case .idle: break
        }
    }

    func updateTheTimer() {
        switch cyclesCount {
        
        // 1. If cycle count reaches zero, reduce one tabataa count and check the tabatta count
        // 2. If tabatta count not equal to 0, then repeat cycle untill tabatta reaches 0.
        // 3. If tabatta count equal to 0, then stop the timer.
        
        case let count where count == 0:
            tabattaCount -= 1
            let isTabattaLive = tabattaCount != 0 && tabattaCount > 0
        
            cyclesCount = isTabattaLive ? TTTimerValues.shared.numberOfCycles : 0
            
            cyclesTimer.timerLabel.text = isTabattaLive ?
                TTUtilities.countString(cyclesCount) :
                TTUtilities.countString(0)
            
            tabattaTimer.timerLabel.text = isTabattaLive ?
                TTUtilities.countString(tabattaCount) :
                TTUtilities.countString(0)
            
            currentWorkOutState = isTabattaLive ?
                .prepare :
                .idle
            
            
        case let count where count != 0 && count > 0 && tabattaCount != 0:
            cyclesTimer.timerLabel.text = TTUtilities.countString(cyclesCount)
            currentWorkOutState = .prepare
            
        default: break
        }

    }
  }
    
extension TTHomeViewController: TTPauseButtonActionDelegate {
    
    func playPauseButtonAction() {
        toggleTimer()
    }
}
