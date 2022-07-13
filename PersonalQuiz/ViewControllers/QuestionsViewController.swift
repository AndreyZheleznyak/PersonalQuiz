import UIKit

class QuestionsViewController: UIViewController {

//MARK: - IB Outlets
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangeStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider! {
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            rangedSlider.maximumValue = answerCount
            rangedSlider.value = answerCount / 2
        }
    }
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answersChosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
//MARK: - IB Actions
    @IBAction func singleButtonAnswerPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let answer = currentAnswers[buttonIndex]
        answersChosen.append(answer)
        nextQuestion()
    }
    
    @IBAction func multipleButtonAnswerPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrint(Double(rangedSlider.value))
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
}

//MARK: - Private Methods
    extension QuestionsViewController {
        private func updateUI() {
            //Hide stacks
            for stackView in [singleStackView, multipleStackView, rangeStackView] {
                stackView?.isHidden = true
            }
            
            // Get current question
            let currentQuestion = questions[questionIndex]
            
            // Set current question for question label
            if questionLabel == nil { return }
            else {
            questionLabel.text = currentQuestion.title
            }
            
            // Calculate progress
            let totalProgress = Float(questionIndex) / Float(questions.count)
            
            //Set progress for questionProgressView
            questionProgressView.setProgress(totalProgress, animated: true)
            
            //Set navigation title
            title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
            
            showCurrentAnswer(for: currentQuestion.responseType)
        }
        
        private func showCurrentAnswer(for type: ResponseType) {
            switch type {
            case .single: showSingleStackView(with: currentAnswers)
            case .multiple: showMultipleStackView(with: currentAnswers)
            case .ranged: showRangeStackView(with: currentAnswers)
            }
        }
        
        private func showMultipleStackView(with answers: [Answer]) {
            multipleStackView.isHidden = false
            
            for (label, answer) in zip(multipleLabels, answers) {
                label.text = answer.title
            }
        }
        
        private func showRangeStackView(with answer: [Answer]) {
            rangeStackView.isHidden = false
            
            rangedLabels.first?.text = answer.first?.title
            rangedLabels.last?.text = answer.last?.title
        }
        
        private func showSingleStackView(with answers: [Answer]) {
            singleStackView.isHidden = false
            
            for (button, answer) in zip(singleButtons, answers) {
                button.setTitle(answer.title, for: .normal)
                
            }
        }
        
        private func nextQuestion() {
            questionIndex += 1
            
            if questionIndex < questions.count {
                updateUI()
                return
            }
            
            performSegue(withIdentifier: "showResult", sender: nil)
        }
    }
