//
//  GameColors.swift
//  matchthecolor
//
//  Created by mymac on 09/04/24.
//

import Foundation
import UIKit

enum StageColors{
    case Yellow
    case Orange
    case Red
    case Green
    
    func color() -> UIColor{
        switch self{
        case .Green:
            return .green
        case .Orange:
            return .orange
        case .Red:
            return .red
        case .Yellow:
            return .yellow
        }
    }
}
