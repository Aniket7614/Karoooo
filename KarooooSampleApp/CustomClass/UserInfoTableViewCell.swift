//
//  UserInfoTableViewCell.swift
//  KarooooSampleApp
//
//  Created by Halcyon Tek on 11/03/23.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblCompanyWebsite: UILabel!
    @IBOutlet weak var lblGeoLocation: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    var userModel: UserModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure()
        mainView.layer.cornerRadius = 8
        mainView.layer.borderWidth = 0.5
        mainView.layer.borderColor = UIColor.systemGray3.cgColor
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOpacity = 0.1
        mainView.layer.shadowColor = UIColor.black.cgColor

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(){
        self.lblName.text = userModel?.name ?? ""
        self.lblEmail.text = userModel?.email ?? ""
        self.lblAddress.text = userModel?.address?.city ?? ""
        self.lblPhone.text = userModel?.address?.city ?? ""
        self.lblCompanyName.text = userModel?.company?.name ?? ""
        self.lblCompanyWebsite.text = userModel?.website ?? ""
        self.lblGeoLocation.text = "\(userModel?.address?.geo?.lat ?? ""), \(userModel?.address?.geo?.lng ?? "")"
    }}
