//
//  InfoViewController.swift
//  VirusSpreadSimulator
//
//  Created by Данил Швец on 10.05.2023.
//

import UIKit

class InfoViewController: UIViewController, UIScrollViewDelegate {
    
    struct UIConstants {
        static let padding: CGFloat = 30
        static let scrollViewPadding: CGFloat = 10
        static let bottomPadding: CGFloat = 50
        static let spacing: CGFloat = 10
        static let mainStackSpacing: CGFloat = 40
        static let buttonHeight: CGFloat = 50
        static let cornerRadius: CGFloat = 20
        static let backButtonPadding: CGFloat = 10
    }
    
    private lazy var groupSizeLabel = UILabel()
    private lazy var groupSizeDescriptionLabel = UILabel()
    private lazy var infectionFactorLabel = UILabel()
    private lazy var infectionFactorDescriptionLabel = UILabel()
    private lazy var timePeriodLabel = UILabel()
    private lazy var timePeriodDescriptionLabel = UILabel()
    private lazy var infoLabel = UILabel()
    private lazy var infoDescriptionLabel = UILabel()
    
    private let scrollView = UIScrollView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.setTitle("НАЗАД", for: .normal)
        return button
    }()
    
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        configureColors()
        configureBackButton()
        configureScrollView()
        configureLabelsTexts()
        configureLabels()
    }
    
    override func viewWillLayoutSubviews() {
        configureColors()
    }
    
    
    // MARK: - Конфигурация элементов интерфейса
    
    private func configureColors() {
        view.backgroundColor = .systemGray6
        backButton.backgroundColor = UIColor(named: "buttonColor")
        backButton.tintColor = .systemGray6
    }
    
    private func configureBackButton() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: view.frame.size.width/20)
        backButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.backButtonPadding).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        backButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        backButton.layer.cornerRadius = UIConstants.cornerRadius
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.scrollViewPadding).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -UIConstants.scrollViewPadding).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.scrollViewPadding).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstants.scrollViewPadding).isActive = true
        scrollView.delegate = self
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func configureLabelsTexts() {
        groupSizeLabel.text = "Количество людей в группе"
        groupSizeDescriptionLabel.text = "Данное значение показывает, сколько всего человек в группе изначально. На экране моделирования данный параметр будет отбражать количество оставшихся здоровых людей в группе."
        
        infectionFactorLabel.text = "Количество заражаемых людей"
        infectionFactorDescriptionLabel.text = "Данное значение показывает, сколько человек может быть заражено уже болеющим человеком. На экране моделирования данный параметр будет отбражать количество зараженных людей в группе."
        
        timePeriodLabel.text = "Период пересчета"
        timePeriodDescriptionLabel.text = "Данное значение показывает, с какой частотой (в секундах) будет производиться пересчет зараженных людей. Чем больше изначальное количество людей в группе, тем больший промежуток времени необходим для пересчета."
        
        infoLabel.text = "Информация"
        infoDescriptionLabel.text = "Чтобы начать процесс вычисления, нажмите на одну из точек, моделирующих человека. Все параметры моделирования должны быть больше 0."
    }
    
    
    private func configureLabels() {
        [groupSizeLabel, infectionFactorLabel, timePeriodLabel, infoLabel].forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 23.0)
            label.numberOfLines = 0
        }
        
        [groupSizeDescriptionLabel, infectionFactorDescriptionLabel, timePeriodDescriptionLabel, infoDescriptionLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 20.0)
            label.numberOfLines = 0
        }
        
        let stackGroupSize = UIStackView(arrangedSubviews: [groupSizeLabel, groupSizeDescriptionLabel])
        let stackInfectionFactor = UIStackView(arrangedSubviews: [infectionFactorLabel, infectionFactorDescriptionLabel])
        let stackTimePeriod = UIStackView(arrangedSubviews: [timePeriodLabel, timePeriodDescriptionLabel])
        let stackInfoPeriod = UIStackView(arrangedSubviews: [infoLabel, infoDescriptionLabel])
        
        [stackGroupSize, stackInfectionFactor, stackTimePeriod, stackInfoPeriod].forEach { innerStack in
            innerStack.translatesAutoresizingMaskIntoConstraints = false
            innerStack.axis = .vertical
            innerStack.distribution = .fillProportionally
            innerStack.spacing = UIConstants.spacing
        }
        
        let stack = UIStackView(arrangedSubviews: [stackGroupSize, stackInfectionFactor, stackTimePeriod, stackInfoPeriod])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = UIConstants.mainStackSpacing
        
        scrollView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackGroupSize.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        stackInfectionFactor.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        stackTimePeriod.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        stackInfoPeriod.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
    }
    
    
    // MARK: - @objc методы
    
    @objc private func backButtonPressed() {
        dismiss(animated: true)
    }

}
