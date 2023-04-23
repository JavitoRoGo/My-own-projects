//
//  GameState.swift
//  RPSLSpock
//
//  Created by Javier Rodríguez Gómez on 21/3/21.
//

import Foundation
import GameplayKit //no recuerdo para qué era esto, si lo quito no salta ningún error. ¿Sería por probar?

// Enums

enum Sign {
    case rock
    case paper
    case scisor
    case lizzard
    case spock
}
enum GameState {
    case win
    case lose
    case tie
}

// Functions

func randomSign() -> Sign {
    let sign = Int.random(in: 0...4)
    if sign == 0 {
        return .rock
    } else if sign == 1 {
        return .paper
    } else if sign == 2 {
        return .scisor
    } else if sign == 3 {
        return .lizzard
    } else {
        return .spock
    }
}

func gameState(mySign: Sign, otherSign: Sign) -> (state: GameState, text: String) {
    switch mySign {
    case .rock:
        switch otherSign {
        case .rock:
            return (.tie, "")
        case .paper:
            return (.lose, "Papel envuelve a piedra")
        case .scisor:
            return (.win, "Y como siempre...\npiedra rompe a tijera")
        case .lizzard:
            return (.win, "Piedra aplasta a lagarto")
        case .spock:
            return (.lose, "Spock pulveriza a piedra")
        }
    case .paper:
        switch otherSign {
        case .rock:
            return (.win, "Papel envuelve a piedra")
        case .paper:
            return (.tie, "")
        case .scisor:
            return (.lose, "Tijera corta a papel")
        case .lizzard:
            return (.lose, "Lagarto come a papel")
        case .spock:
            return (.win, "Papel desacredita a Spock")
        }
    case .scisor:
        switch otherSign {
        case .rock:
            return (.lose, "Y como siempre...\npiedra rompe a tijera")
        case .paper:
            return (.win, "Tijera corta a papel")
        case .scisor:
            return (.tie, "")
        case .lizzard:
            return (.win, "Tijera trocea a lagarto")
        case .spock:
            return (.lose, "Spock desintegra a tijera")
        }
    case .lizzard:
        switch otherSign {
        case .rock:
            return (.lose, "Piedra aplasta a lagarto")
        case .paper:
            return (.win, "Lagarto come a papel")
        case .scisor:
            return (.lose, "Tijera trocea a lagarto")
        case .lizzard:
            return (.tie, "")
        case .spock:
            return (.win, "Lagarto envenena a Spock")
        }
    case .spock:
        switch otherSign {
        case .rock:
            return (.win, "Spock pulveriza a piedra")
        case .paper:
            return (.lose, "Papel desacredita a Spock")
        case .scisor:
            return (.win, "Spock desintegra a tijera")
        case .lizzard:
            return (.lose, "Lagarto envenena a Spock")
        case .spock:
            return (.tie, "")
        }
    }
}
