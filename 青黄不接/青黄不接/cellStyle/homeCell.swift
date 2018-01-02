//
//  homeCell.swift
//  青黄不接
//
//  Created by Mr.Ace on 2018/1/2.
//  Copyright © 2018年 Mr.Ace. All rights reserved.
//

import UIKit

class homeCell: UITableViewCell {
    var title:String = ""{
        didSet{
            if(title != oldValue){
                titleLabel.text = title
            }
        }
    }
    var author:String = ""{
        didSet{
            if(author != oldValue){
                authorLabel.text = author
            }
        }
    }
    var digest:String = ""{
        didSet{
            if(digest != oldValue){
                digestTextView.text = digest
            }
        }
    }
    var newestChapTitle:String = ""{
        didSet{
            if(newestChapTitle != oldValue){
                newestChapTitleLabel.text = newestChapTitle
            }
        }
    }
    var introduction:String = ""{
        didSet{
            if(introduction != oldValue){
                introductionTextView.text = introduction
            }
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var digestTextView: UITextView!
    @IBOutlet var newestChapTitleLabel: UILabel!
    @IBOutlet var introductionTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
