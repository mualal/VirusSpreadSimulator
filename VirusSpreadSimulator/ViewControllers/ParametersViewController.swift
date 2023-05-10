//
//  ParametersViewController.swift
//  VirusSpreadSimulator
//
//  Created by Данил Швец on 04.05.2023.
//

import UIKit

final class ParametersViewController: UIViewController {
    
    struct UIConstants {
        static let padding: CGFloat = 30
        static let bottomPadding: CGFloat = 50
        static let iconPadding: CGFloat = -30
        static let buttonHeight: CGFloat = 80
        static let cornerRadius: CGFloat = 20
        static let spacing: CGFloat = 10
        static let borderWidth: CGFloat = 0.8
        static let stackHeight: CGFloat = 200
        static let buttonSize: CGFloat = 35
        static let paddingInfo: CGFloat = 15
    }
    
    private let groupIcon: UIImageView = UIImageView(image: UIImage(systemName: "person.2.fill")!)
    private lazy var groupSizeTextField = UITextField()
    private let infectionIcon: UIImageView = UIImageView(image: UIImage(systemName: "allergens")!)
    private lazy var infectionFactorTextField = UITextField()
    private let timeIcon: UIImageView = UIImageView(image: UIImage(systemName: "timer")!)
    private lazy var timePeriodTextField = UITextField()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        return button
    }()
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.buttonSize, weight: .bold, scale: .large)
    
    private lazy var groupStack = UIStackView()
    private lazy var infectionStack = UIStackView()
    private lazy var timeStack = UIStackView()
    
    private lazy var openNextViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(openNextViewButtonPressed), for: .touchUpInside)
        button.setTitle("Запустить моделирование", for: .normal)
        return button
    }()
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInfoButton()
        configureNextViewControllerButton()
        configureColors()
        configureParametersStack()
        addDoneButton()
    }
    
    
    override func viewWillLayoutSubviews() {
        configureColors()
    }
    
    
    // MARK: - Конфигурация элементов интерфейса
    
    private func configureInfoButton() {
        view.addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.paddingInfo).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: UIConstants.buttonSize).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonSize).isActive = true
        let infoButtonImage = UIImage(systemName: "info.circle", withConfiguration: largeConfig)
        infoButton.setImage(infoButtonImage, for: .normal)
        infoButton.tintColor = .systemOrange
        infoButton.imageView?.contentMode = .scaleAspectFill
    }
    
    private func configureGroupStack() -> UIStackView {
        let groupStack = UIStackView(arrangedSubviews: [groupIcon, groupSizeTextField])
        groupSizeTextField.textColor = UIColor(named: "fontColor")
        groupSizeTextField.clearButtonMode = .always
        groupSizeTextField.keyboardType = .asciiCapableNumberPad
        groupSizeTextField.attributedPlaceholder = NSAttributedString(string: "Количество людей в группе",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        view.addSubview(groupStack)
        return groupStack
    }
    
    private func configureInfectionStack() -> UIStackView {
        let infectionStack = UIStackView(arrangedSubviews: [infectionIcon, infectionFactorTextField])
        infectionFactorTextField.textColor = UIColor(named: "fontColor")
        infectionFactorTextField.clearButtonMode = .always
        infectionFactorTextField.keyboardType = .asciiCapableNumberPad
        infectionFactorTextField.attributedPlaceholder = NSAttributedString(string: "Количество заражаемых людей",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        view.addSubview(infectionStack)
        return infectionStack
    }
    
    private func configureTimeStack() -> UIStackView {
        let timeStack = UIStackView(arrangedSubviews: [timeIcon, timePeriodTextField])
        timePeriodTextField.textColor = UIColor(named: "fontColor")
        timePeriodTextField.clearButtonMode = .always
        timePeriodTextField.keyboardType = .asciiCapableNumberPad
        timePeriodTextField.attributedPlaceholder = NSAttributedString(string: "Период пересчета (секунды)",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        view.addSubview(timeStack)
        return timeStack
    }
    
    private func configureParametersStack() {
        groupStack = configureGroupStack()
        infectionStack = configureInfectionStack()
        timeStack = configureTimeStack()
        
        [groupIcon, infectionIcon, timeIcon].forEach {icon in
            icon.heightAnchor.constraint(equalTo: groupStack.heightAnchor, constant: UIConstants.iconPadding).isActive = true
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        }
        
        [groupStack, infectionStack, timeStack].forEach { stack in
            stack.axis = .horizontal
            stack.spacing = UIConstants.spacing
            stack.alignment = .center
            stack.layer.borderWidth = UIConstants.borderWidth
            stack.layer.cornerRadius = UIConstants.cornerRadius
            stack.isLayoutMarginsRelativeArrangement = true
            stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
        }
        
        let stack = UIStackView(arrangedSubviews: [groupStack, infectionStack, timeStack])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = UIConstants.spacing
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: 2 * UIConstants.bottomPadding).isActive = true
        stack.heightAnchor.constraint(equalToConstant: UIConstants.stackHeight).isActive = true
        stack.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive = true
    }
    
    private func configureNextViewControllerButton() {
        view.addSubview(openNextViewButton)
        openNextViewButton.translatesAutoresizingMaskIntoConstraints = false
        openNextViewButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: view.frame.size.width/20)
        openNextViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openNextViewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.bottomPadding).isActive = true
        openNextViewButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        openNextViewButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        openNextViewButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        openNextViewButton.layer.cornerRadius = UIConstants.cornerRadius
    }
    
    
    private func configureColors() {
        view.backgroundColor = .systemGray6
        
        openNextViewButton.backgroundColor = UIColor(named: "buttonColor")
        openNextViewButton.tintColor = .systemGray6
        
        groupIcon.tintColor = UIColor(named: "personColor")
        infectionIcon.tintColor = UIColor(named: "infectionColor")
        timeIcon.tintColor = UIColor(named: "timeColor")
        
        groupStack.layer.borderColor = UIColor(named: "textfieldBorderColor")?.cgColor
        infectionStack.layer.borderColor = UIColor(named: "textfieldBorderColor")?.cgColor
        timeStack.layer.borderColor = UIColor(named: "textfieldBorderColor")?.cgColor
    }
    
    private func addDoneButton() {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        doneToolbar.setItems([flexSpace, doneButton], animated: true)
        groupSizeTextField.inputAccessoryView = doneToolbar
        infectionFactorTextField.inputAccessoryView = doneToolbar
        timePeriodTextField.inputAccessoryView = doneToolbar
    }
    
    
    // MARK: - Функции отображения других экранов
    
    private func presentSimulationViewController() {
        let simulationViewController = SimulationViewController()
        if groupSizeTextField.text != "" {
            simulationViewController.groupSize = Int(groupSizeTextField.text!)!
        }
        if infectionFactorTextField.text != "" {
            simulationViewController.infectionFactor = Int(infectionFactorTextField.text!)!
        }
        if timePeriodTextField.text != "" {
            simulationViewController.timePeriod = Int(timePeriodTextField.text!)!
        }
        simulationViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(simulationViewController, animated: true)
    }
    
    private func presentInfoViewController() {
        let infoViewController = InfoViewController()
        self.navigationController?.present(infoViewController, animated: true)
    }
    
    
    // MARK: - @objc методы
    
    @objc private func infoButtonPressed() {
        presentInfoViewController()
    }
    
    @objc private func openNextViewButtonPressed() {
        presentSimulationViewController()
    }
    
    @objc private func doneButtonAction() {
        view.endEditing(true)
    }
    
    
}
