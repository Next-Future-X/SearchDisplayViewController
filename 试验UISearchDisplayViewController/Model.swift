//
//  Model.swift
//  试验UISearchDisplayViewController
//
//  Created by 袁向阳 on 17/4/18.
//  Copyright © 2017年 YXY.cn. All rights reserved.
//

import UIKit

class Model: NSObject {
    var name = ""
    var subName = "" {
        didSet {
            pinYin = PinyinHelper.toHanyuPinyinStringWithNSString(getDescription(), withHanyuPinyinOutputFormat: pinyinFormat, withNSString: "")
        }
    }
    var pinYin = ""
    
    private var pinyinFormat: HanyuPinyinOutputFormat = {
        let format = HanyuPinyinOutputFormat()
        format.toneType = ToneTypeWithoutTone
        format.caseType = CaseTypeUppercase
        format.vCharType = VCharTypeWithV
        return format
    }()
    
    private func getDescription() -> String {
        return self.name + self.subName
    }
}
