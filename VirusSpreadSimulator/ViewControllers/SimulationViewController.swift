//
//  SimulationViewController.swift
//  VirusSpreadSimulator
//
//  Created by Данил Швец on 05.05.2023.
//

import UIKit

class SimulationViewController: UIViewController, UIScrollViewDelegate {
    
    
    struct UIConstants {
        static let padding: CGFloat = 30
        static let bottomPadding: CGFloat = 50
        static let iconPadding: CGFloat = -20
        static let buttonHeight: CGFloat = 80
        static let cornerRadius: CGFloat = 20
        static let spacing: CGFloat = 5
        static let horizontalSpacing: CGFloat = 15
        static let borderWidth: CGFloat = 0.8
        static let stackHeight: CGFloat = 150
        static let circleSize: CGFloat = 10
    }
    
    lazy var groupSize = 0
    lazy var infectionFactor = 0
    lazy var timePeriod = 0
    
    private lazy var dotsDictionary = [Int: Person]()
    private lazy var infectedDotsDictionary = [Int: Person]()
    private lazy var distanceBetweenDots = [Int: [Int: Double]]()
    private lazy var showNumberOfInfected = 0
    private lazy var widthOfMyView: CGFloat = 0
    private lazy var heightOfMyView: CGFloat = 0
    private lazy var idOfClosestDots = [Int]()
    private lazy var flagStartCalculating = false
    private lazy var dividerForRadius = 1
    
    private let groupIcon: UIImageView = UIImageView(image: UIImage(systemName: "person.2.fill")!)
    private lazy var groupSizeLabel = UILabel()
    private let infectionIcon: UIImageView = UIImageView(image: UIImage(systemName: "allergens")!)
    private lazy var infectionFactorLabel = UILabel()
    private let timeIcon: UIImageView = UIImageView(image: UIImage(systemName: "timer")!)
    private lazy var timePeriodLabel = UILabel()
    private lazy var animatedCircle: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var circleLayer = CAShapeLayer()
    private var calculateTimer: Timer?
    
    private lazy var groupStack = UIStackView()
    private lazy var infectionStack = UIStackView()
    private lazy var timeStack = UIStackView()
    
    private let scrollView = UIScrollView()
    private lazy var myView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var openNextViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(openNextViewButtonPressed), for: .touchUpInside)
        button.setTitle("Изменить параметры", for: .normal)
        return button
    }()

    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureColors()
        configureTopLabels()
        configureLabelsTexts()
        configurePreviousViewControllerButton()
        configureScrollView()
        addMyView()
        if infectedDotsDictionary.count == 1 {
            print("Let's go!")
        }
        
    }
    
    
    // MARK: - override func
    
    override func viewDidAppear(_ animated: Bool) {
        generatePersons()
        addCircleView()
        widthOfMyView = myView.bounds.width
        heightOfMyView = myView.bounds.height
        DispatchQueue.global(qos: .background).sync {
            self.calculateDistancesBetweenAllPersons()
        }
        calculateDivider()
    }
    
    override func viewWillLayoutSubviews() {
        configureColors()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        calculateTimer?.invalidate()
    }
    
    
    // MARK: - Конфигурация элементов интерфейса
    
    private func configureGroupStack() -> UIStackView {
        let groupStack = UIStackView(arrangedSubviews: [groupIcon, groupSizeLabel])
        view.addSubview(groupStack)
        return groupStack
    }
    
    private func configureInfectionStack() -> UIStackView {
        let infectionStack = UIStackView(arrangedSubviews: [infectionIcon, infectionFactorLabel])
        view.addSubview(infectionStack)
        return infectionStack
    }
    
    private func configureTimeStack() -> UIStackView {
        let timeStack = UIStackView(arrangedSubviews: [timeIcon, timePeriodLabel])
        view.addSubview(timeStack)
        return timeStack
    }
    
    private func configureLabelsStack() -> UIStackView {
        groupStack = configureGroupStack()
        infectionStack = configureInfectionStack()
        timeStack = configureTimeStack()
        
        [groupIcon, infectionIcon, timeIcon].forEach {icon in
            icon.heightAnchor.constraint(equalTo: groupStack.heightAnchor, constant: UIConstants.iconPadding).isActive = true
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        }
        
        [groupStack, infectionStack, timeStack].forEach { stack in
            stack.axis = .horizontal
            stack.alignment = .center
            stack.spacing = UIConstants.horizontalSpacing
            stack.isLayoutMarginsRelativeArrangement = true
            stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
        }
        
        let stack = UIStackView(arrangedSubviews: [groupStack, infectionStack, timeStack])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = UIConstants.spacing
        
        return stack
    }
    
    private func addCircleView() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: animatedCircle.frame.width / 2, y: animatedCircle.frame.height / 2), radius: animatedCircle.bounds.width / 3, startAngle: -.pi/2, endAngle: .pi/2*3, clockwise: true)
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor(named: "timeColor")?.cgColor
        circleLayer.lineWidth = 5.0
        circleLayer.strokeEnd = 1.0
        animatedCircle.layer.addSublayer(circleLayer)
    }
    
    private func configureTopLabels() {
        let stack = UIStackView(arrangedSubviews: [configureLabelsStack(), animatedCircle])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = UIConstants.spacing
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.bottomPadding).isActive = true
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        stack.heightAnchor.constraint(equalToConstant: UIConstants.stackHeight).isActive = true
    }
    
    private func configureLabelsTexts() {
        groupSizeLabel.text = String(groupSize)
        groupSizeLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        infectionFactorLabel.text = String(showNumberOfInfected)
        infectionFactorLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        timePeriodLabel.text = String(timePeriod)
        timePeriodLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: timePeriodLabel.bottomAnchor, constant: UIConstants.padding).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: openNextViewButton.topAnchor, constant: -UIConstants.padding).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        scrollView.layer.cornerRadius = UIConstants.cornerRadius
        scrollView.layer.borderWidth = UIConstants.borderWidth
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 7.0
        scrollView.delegate = self
        
    }
    
    private func addMyView() {
        scrollView.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        myView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        myView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        myView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        myView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        myView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(myViewTapped))
        myView.addGestureRecognizer(tapGestureRecognizer)
        myView.isUserInteractionEnabled = true
    }
    
    
    private func configurePreviousViewControllerButton() {
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
        
        groupIcon.tintColor = UIColor(named: "personColor")
        infectionIcon.tintColor = UIColor(named: "infectionColor")
        timeIcon.tintColor = UIColor(named: "timeColor")
        
        groupSizeLabel.textColor = UIColor(named: "fontColor")
        infectionFactorLabel.textColor = UIColor(named: "fontColor")
        timePeriodLabel.textColor = UIColor(named: "fontColor")
        
        openNextViewButton.backgroundColor = UIColor(named: "infectionColor")
        openNextViewButton.tintColor = .systemGray6
        
        myView.backgroundColor = UIColor(named: "fieldBackgroundColor")
        scrollView.backgroundColor = UIColor(named: "fieldBackgroundColor")
        scrollView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return myView
    }
    
    
    // MARK: - Функции вычисления необходимых для моделирования парметров и обновления интерфейса
    
    private func calculateDivider() {
        var countOfPersons = groupSize
        while countOfPersons / 10 > 0 {
            countOfPersons /= 10
            dividerForRadius += 1
        }
    }
    
    private func calculateDistancesBetweenAllPersons() {
        for i in 0..<dotsDictionary.count {
            var innerDict = [Int: Double]()
            for j in 0..<dotsDictionary.count {
                if i != j {
                    let distance = sqrt(pow((dotsDictionary[i]?.coordinates.x)! - (dotsDictionary[j]?.coordinates.x)!, 2) + pow((dotsDictionary[i]?.coordinates.y)! - (dotsDictionary[j]?.coordinates.y)!, 2))
                    innerDict[j] = distance
                }
            }
            distanceBetweenDots[i] = innerDict
        }
    }
    
    
    private func generatePersons() {
        for i in 0..<groupSize {
            let x = Double.random(in: Double(UIConstants.circleSize)...Double(myView.bounds.width - UIConstants.circleSize))
            let y = Double.random(in: Double(UIConstants.circleSize)...Double(myView.bounds.height - UIConstants.circleSize))
            let person = Person(color: UIColor(named: "dotsColor")?.cgColor, isInfected: false, coordinates: CGPoint(x: x, y: y), id: i)
            dotsDictionary[i] = person
            myView.layer.addSublayer(person.drawCircle())
        }
    }
    
    private func redrawPersons(infectedPerson: Person) {
        myView.layer.replaceSublayer(myView.layer.sublayers![infectedPerson.id], with: infectedPerson.drawCircle())
        groupSize -= 1
        showNumberOfInfected += 1
        groupSizeLabel.text = String(groupSize)
        infectionFactorLabel.text = String(showNumberOfInfected)
        infectedDotsDictionary[infectedPerson.id] = infectedPerson
        dotsDictionary.removeValue(forKey: infectedPerson.id)
    }
    
    private func calculateInfectedPersons() {
        for (id, _) in infectedDotsDictionary {
            let numberYouShouldInfect = Int.random(in: 1...infectionFactor)
            
            for _ in 1...numberYouShouldInfect {
                var minDistance = 1000000.0
                var minId = 0
                if distanceBetweenDots[id] != nil {
                    for i in 0...distanceBetweenDots[id]!.count {
                        if distanceBetweenDots[id]![i] != nil {
                            if distanceBetweenDots[id]![i]! < minDistance {
                                minDistance = distanceBetweenDots[id]![i]!
                                minId = i
                            }
                        }
                    }
                }
                if minDistance > Double(max(widthOfMyView, heightOfMyView) / Double(dividerForRadius)) {
                    infectedDotsDictionary.removeValue(forKey: minId)
                } else {
                    idOfClosestDots.append(minId)
                    distanceBetweenDots[id]!.removeValue(forKey: minId)
                }
            }
        }
    }
    
    private func updateInfectedPersons() {
        if idOfClosestDots != [] {
            for minId in idOfClosestDots {
                if dotsDictionary[minId] != nil {
                    let infectedPerson = Person(color: UIColor(named: "infectedDotsColor")?.cgColor, isInfected: true, coordinates: CGPoint(x: dotsDictionary[minId]!.coordinates.x, y: dotsDictionary[minId]!.coordinates.y), id: minId)
                    self.redrawPersons(infectedPerson: infectedPerson)
                }
            }
        }
    }
    
    private func animateCircle(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = duration
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.isRemovedOnCompletion = false
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    private func startCalculatingAndUpdating() {
        var numberOfHealthyPersons = -1
        var numberOfRepeats = 0
        animateCircle(duration: TimeInterval(timePeriod))
        if calculateTimer == nil {
            calculateTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timePeriod), repeats: true) { timer in
                self.animateCircle(duration: TimeInterval(self.timePeriod))
                DispatchQueue.global().async {
                    DispatchQueue.main.sync {
                        self.updateInfectedPersons()
                        if self.dotsDictionary.count == 0 {
                            timer.invalidate()
                            self.showResult(title: "ВСЕ ЗАРАЖЕНЫ", imageName: "allInfected", buttontext: "OK")
                        } else if numberOfHealthyPersons != self.dotsDictionary.count {
                            numberOfHealthyPersons = self.dotsDictionary.count
                        } else if numberOfHealthyPersons == self.dotsDictionary.count {
                            numberOfRepeats += 1
                        }
                        
                        if numberOfRepeats == 3 {
                            timer.invalidate()
                            self.showResult(title: "ОСТАЛИСЬ ЗДОРОВЫЕ", imageName: "badResult", buttontext: "OK")
                        }
                    }
                    DispatchQueue.global().sync {
                        self.idOfClosestDots.removeAll()
                        self.calculateInfectedPersons()
                    }
                    
                }
            }
        }
    }
    
    private func showResult(title: String, imageName: String, buttontext: String) {
        let popUpWindow = PopUpViewController(title: title, imageName: imageName, buttontext: buttontext)
        present(popUpWindow, animated: true, completion: nil)
    }
    
    
    // MARK: - @objc методы
    
    @objc private func myViewTapped(recognizer : UIGestureRecognizer) {
        let tappedPoint: CGPoint = recognizer.location(in: self.myView)
        for (id, person) in dotsDictionary {
            if person.coordinates.x < tappedPoint.x + 10.0 && person.coordinates.x > tappedPoint.x - 10.0 && person.coordinates.y > tappedPoint.y - 10.0 && person.coordinates.y < tappedPoint.y + 10.0 && person.isInfected != true {
                let infectedPerson = Person(color: UIColor(named: "infectedDotsColor")?.cgColor, isInfected: true, coordinates: CGPoint(x: person.coordinates.x, y: person.coordinates.y), id: id)
                redrawPersons(infectedPerson: infectedPerson)
                if !flagStartCalculating {
                    flagStartCalculating = true
                    if infectionFactor != 0 && timePeriod != 0 {
                        startCalculatingAndUpdating()
                    }
                }
            }
        }
        
    }
    
    @objc private func openNextViewButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}
