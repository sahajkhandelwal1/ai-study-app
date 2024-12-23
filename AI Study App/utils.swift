//
//  utils.swift
//  AI Study App
//
//  Created by Sahaj on 11/24/24.
//

import SwiftUI

func colorForAnswer(_ answer: Bool?) -> Color {
    if answer == true {
        return .green
    } else if answer == false {
        return .red
    } else {
        return .gray
    }
}
