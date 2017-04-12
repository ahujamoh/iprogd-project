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
        malertViewConfig.margin = 16
        malertViewConfig.buttonsAxis = .horizontal
        malertViewConfig.backgroundColor = UIColor(red:0.1, green:1.0, blue:0.1, alpha:1.0)
        malertViewConfig.textColor = .white
        malertViewConfig.textAlign = .center
        return malertViewConfig
    }


}
