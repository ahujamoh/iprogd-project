//
//  Constants.swift
//  Moodstory
//
//  Created by Muhammad Mustafa Saeed on 3/15/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit



//Global variables
struct GlobalVariables {
    static let blue = UIColor.rbg(r: 129, g: 144, b: 255)
    static let purple = UIColor.rbg(r: 161, g: 114, b: 255)
    static let KEY_UID = "uid"
    static let GOOGLE_MAPS_KEY = "AIzaSyCuOsyy--bz0Jo6F8OPhG45SJgBF45cOcM"
}

//Extensions
extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}
