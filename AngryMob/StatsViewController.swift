//
//  StatsViewController.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 27/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RxSwift
import RxCocoa
import DatePickerDialog
import PieCharts


public class StatsViewController: UIViewController {

    @IBOutlet weak var placeHolder: UIView!
    @IBOutlet weak var menPercent: UILabel!
    @IBOutlet weak var womenPercent: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var submitButton: UIButton!


    let api = APIClient.sharedInstance

    @IBOutlet weak var genderChart: PieChart!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var startDateButton: UIButton!

    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var hoursButton: UIButton!
    @IBOutlet weak var emotionsButton: UIButton!

    @IBOutlet weak var leadingConst: NSLayoutConstraint!
    @IBOutlet weak var widthConst: NSLayoutConstraint!

    var ageVC: AgeViewController!
    var emotionsVC: EmotionsViewController!
    var hoursVC: HoursViewController!


    let pinkColor = UIColor(red:0.94, green:0.45, blue:0.45, alpha:1.0)
    let blueColor = UIColor(red:0.24, green:0.67, blue:0.90, alpha:1.0)

    let active = UIColor(red:0.21, green:0.04, blue:0.23, alpha:1.0)
    let inactive = UIColor(red:0.64, green:0.56, blue:0.65, alpha:1.0)

    let disposeBag = DisposeBag()

    var since: Date = Date()
    var to: Date = Date()

    var gender: Variable<Gender?> = Variable(nil)
    var emotion: Variable<EmotionModel?> = Variable(nil)
    var age: Variable<Age?> = Variable(nil)
    var hours: Variable<Hours?> = Variable(nil)
//    var age: Variable<?> = Variable(nil)
//    var hours: Variable<?> = Variable(nil)

//    lazy var downloadInfo = Observable.combineLatest(self.gender.asObservable(), self.emotion.asObservable()) { gender, emotion in
//
//    }

    @IBOutlet weak var ageContainer: UIView!
    @IBOutlet weak var hoursContainer: UIView!
    @IBOutlet weak var emotionsContainer: UIView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Statistics"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red:0.21, green:0.04, blue:0.23, alpha:1.0), NSFontAttributeName: UIFont(name: "Exo2-Bold", size: 20)!]

        topView.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 8

        startDateButton.setTitle(Date().date, for: .normal)
        startDateButton.layer.cornerRadius = 8
        startDateButton.layer.borderColor = UIColor(red:0.21, green:0.04, blue:0.23, alpha:1.0).cgColor
        startDateButton.layer.borderWidth = 2

        startDateButton.rx.tap.subscribe(onNext:{ [weak self] in
            DatePickerDialog().show(title: "Select start date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
                guard let date = date else { return }
                self?.since = date
                self?.startDateButton.setTitle(date.date, for: .normal)
            }
        }).addDisposableTo(disposeBag)

        // end

        endDateButton.setTitle(Date().date, for: .normal)
        endDateButton.layer.cornerRadius = 8
        endDateButton.layer.borderColor = UIColor(red:0.21, green:0.04, blue:0.23, alpha:1.0).cgColor
        endDateButton.layer.borderWidth = 2

        endDateButton.rx.tap.subscribe(onNext:{ [weak self] in
            DatePickerDialog().show(title: "Select end date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
                guard let date = date else { return }
                self?.to = date
                self?.endDateButton.setTitle(date.date, for: .normal)
            }
        }).addDisposableTo(disposeBag)

        genderChart.models = [
            PieSliceModel(value: 60, color: blueColor),
            PieSliceModel(value: 40, color: pinkColor)
        ]
        
        self.placeHolder.isHidden = false

        self.ageButton.setTitleColor(active, for: .normal)
        self.hoursButton.setTitleColor(inactive, for: .normal)
        self.emotionsButton.setTitleColor(inactive, for: .normal)

        setupButtons()

        self.ageContainer.alpha = 1
        self.hoursContainer.alpha = 0
        self.emotionsContainer.alpha = 0


        Observable.combineLatest(self.gender.asObservable(), self.emotion.asObservable(), self.age.asObservable(), hours.asObservable()).subscribe(onNext: { gen, emo, ag, ho in

            guard let gender = gen, let emotion = emo, let age = ag, let hour = ho else {
                
                return
            }

            self.placeHolder.isHidden = true
            self.hoursVC.showHours(ageObject: hour)
            self.ageVC.showAge(ageObject: age)
            self.emotionsVC.presentEmotion(emotion: emotion)
            self.presentGender(gender: gender)
        }).addDisposableTo(disposeBag)
    }

    func presentGender(gender: Gender) {
        self.summaryLabel.text = "\(gender.female + gender.male)"

        let doubleman: Double = (Double(gender.male) / (Double(gender.female) + Double(gender.male))) * 100
        self.menPercent.text = "\(Int(doubleman)) %"

        let doublewoman = 100 - Int(doubleman)
        self.womenPercent.text = "\(doublewoman) %"

        self.genderChart.removeSlices()
        self.genderChart.models = [
            PieSliceModel(value: Double(Int(doubleman)), color: self.blueColor),
            PieSliceModel(value: Double(doublewoman), color: self.pinkColor)
        ]
    }

    func setupButtons() {
        ageButton.rx.tap.subscribe(onNext:{ [weak self] in
            guard let `self` = self else { return }
            self.configureButtons(button: self.ageButton)
        }).addDisposableTo(disposeBag)

        hoursButton.rx.tap.subscribe(onNext:{ [weak self] in
            guard let `self` = self else { return }
            self.configureButtons(button: self.hoursButton)
        }).addDisposableTo(disposeBag)

        emotionsButton.rx.tap.subscribe(onNext:{ [weak self] in
            guard let `self` = self else { return }
            self.configureButtons(button: self.emotionsButton)
        }).addDisposableTo(disposeBag)

        submitButton.rx.tap.subscribe(onNext:{ [weak self] in
            guard let `self` = self else { return }

            self.gender.value = nil
            self.emotion.value = nil
            self.age.value = nil
            self.hours.value = nil

            self.genderSummary()
            self.getEmotionsSummary()
            self.ageSummary()
            self.hoursSummary()

        }).addDisposableTo(disposeBag)
    }

    func configureButtons(button: UIButton) {
        self.ageButton.setTitleColor(inactive, for: .normal)
        self.hoursButton.setTitleColor(inactive, for: .normal)
        self.emotionsButton.setTitleColor(inactive, for: .normal)

        button.setTitleColor(active, for: .normal)

        leadingConst.constant = button.frame.origin.x
        widthConst.constant = button.frame.size.width

        view.setNeedsLayout()

        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: nil)

        presentContainer(index: button.tag)
    }

    func presentContainer(index: Int) {
        switch index {
        case 1:
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
                self?.ageContainer.alpha = 1
                self?.hoursContainer.alpha = 0
                self?.emotionsContainer.alpha = 0
                }, completion: nil)
        case 2:
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
                self?.ageContainer.alpha = 0
                self?.hoursContainer.alpha = 1
                self?.emotionsContainer.alpha = 0
                }, completion: nil)
        case 3:
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
                self?.ageContainer.alpha = 0
                self?.hoursContainer.alpha = 0
                self?.emotionsContainer.alpha = 1
                }, completion: nil)
        default:
            break
        }
    }

    func genderSummary() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        api.getGenderSummary(from: formatter.string(from: since), to: formatter.string(from: to)).bind(to: gender)
        .addDisposableTo(disposeBag)
    }

    func getEmotionsSummary() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        api.getEmotionSummary(from: formatter.string(from: since), to: formatter.string(from: to)).bind(to: emotion).addDisposableTo(disposeBag)
    }

    public func ageSummary() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        api.getAgeSummary(from: formatter.string(from: since), to: formatter.string(from: to)).bind(to: age)
        .addDisposableTo(disposeBag)
    }

    public func hoursSummary() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        api.getHoursSummary(from: formatter.string(from: since), to: formatter.string(from: to)).bind(to: hours).addDisposableTo(disposeBag)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "age" {
            let dest = segue.destination as! AgeViewController
            self.ageVC = dest
        } else if segue.identifier == "hours" {
            let dest = segue.destination as! HoursViewController
            self.hoursVC = dest
        } else if segue.identifier == "emotions" {
            let dest = segue.destination as! EmotionsViewController
            self.emotionsVC = dest
        }
    }

}
