//
//  StaffDetailsViewController.swift
//  Uni Saar
//
//  Created by Ali Al-Hasani on 1/10/20.
//  Copyright © 2020 Ali Al-Hasani. All rights reserved.
//

import UIKit
import PKHUD
class StaffDetailsViewController: UIViewController {
    @IBOutlet weak var staffTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contactTextView: UITextView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigateButton: UIButton!
    var staffId: Int?
    var staff = StaffDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigateButton.isHidden = true
        bindViewModel()
        //meal.loadGetMockMenu()
        // Do any additional setup after loading the view.
    }
    func bindViewModel() {
        staff.staffDetails.bind { [weak self] staff in
            self?.staffTitleLabel.text = staff.titleText
            self?.nameLabel.text = staff.fullName
            if let email = staff.email {
                self?.emailTextView.text = email
            }
            if staff.address != " - \n\n" {
                self?.navigateButton.isHidden = false
            }
            self?.addressLabel.text = staff.address
            self?.contactTextView.text = staff.contactText
            self?.genderLabel.text = staff.genderText
            self?.title = staff.fullName
            if let imageURL = staff.imageURL {
                self?.imageView.af_setImage(withURL: imageURL)
            }
        }
        staff.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
        if let staffID = staffId {
            staff.loadGetStaffDetails(staffId: staffID)
        }
        staff.showLoadingIndicator.bind {  [weak self] visible in
            if let `self` = self {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide()
            }
        }
    }

    // MARK: - Navigation
    internal struct SegueIdentifiers {
        static let toStaffAddress = "toAddress"
    }
    @IBAction func navigateAction(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifiers.toStaffAddress, sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SegueIdentifiers.toStaffAddress, let destination = segue.destination as? UINavigationController,
            let destinationViewController = destination.topViewController as? CampusViewController {
            destinationViewController.staffAddress = staff.staffDetails.value.staffDetailsModel?.building ?? staff.staffDetails.value.staffDetailsModel?.city
        }
    }
}
extension StaffDetailsViewController: SingleButtonDialogPresenter { }
