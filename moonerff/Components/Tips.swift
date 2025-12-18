//
//  Tips.swift
//  moonerff
//
//  Created by AFP FED 26 on 18/12/25.
//

import SwiftUI

struct Tip: Identifiable {
    
    var id = UUID()
    var tips: String
}

let tips: [Tip] = [
    Tip(tips: "Build a consistent morning routine, even on weekends"  ),
    Tip(tips: "Encourage daytime physical activity to build healthy sleep pressure"),
    Tip(tips: "Separate daytime productivity from nighttime rest mentally."),
    Tip(tips: "Accept lighter sleep and focus on sleep quality, not perfection"),
    Tip(tips: "Reduce caffeine reliance, especially later in the day.")]

