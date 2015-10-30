//
//  Meme.swift
//  MemeMe
//
//  Created by Hyun on 2015. 10. 30..
//  Copyright © 2015년 wook2. All rights reserved.
//

import Foundation

import UIKit


class Meme {
    var bottomText:String!
    var topText:String!
    var originalImage:UIImage!
    var inputMemed:UIImage!

    
    init(bottomText:String, topText:String, originalImage:UIImage, inputMemed:UIImage) {
        self.bottomText = bottomText
        self.topText    = topText
        self.originalImage = originalImage
        self.inputMemed = inputMemed
    }
    
    
}