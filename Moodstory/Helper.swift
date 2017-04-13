//
//  Helper.swift
//  Moodstory
//
//  Created by Sara Eriksson on 2017-04-12.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import Malert

class Helper {

    class func setUpSecondExampleCustomMalertViewConfig() -> MalertViewConfiguration {
        var malertViewConfig = MalertViewConfiguration()
        malertViewConfig.margin = 20
        malertViewConfig.buttonsAxis = .horizontal
        malertViewConfig.backgroundColor = .white
        malertViewConfig.textColor = UIColor(red:0.0, green:0.64, blue:0.17, alpha:1.0)
        malertViewConfig.textAlign = .center
        return malertViewConfig
    }


}
