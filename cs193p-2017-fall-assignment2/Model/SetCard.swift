//
//  SetCard.swift
//  cs193p-2017-fall-assignment2
//
//  Created by Ksenia Surikova on 25.05.2022.
//

import Foundation

struct SetCard: Equatable, CustomStringConvertible {

    private(set) var firstSign: Sign
    private(set) var secondSign: Sign
    private(set) var thirdSign: Sign
    private(set) var fourthSign: Sign

    init (_ firstSign: Sign, _ secondSign: Sign, _ thirdSign: Sign, _ fourthSign: Sign) {
        self.firstSign = firstSign
        self.secondSign = secondSign
        self.thirdSign = thirdSign
        self.fourthSign = fourthSign
    }

    var description: String {
        "\(firstSign)\(secondSign)\(thirdSign)\(fourthSign)"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.firstSign == rhs.firstSign && lhs.secondSign == rhs.secondSign
            && lhs.thirdSign == rhs.thirdSign && lhs.fourthSign == rhs.fourthSign
    }

    static func isSet(cardsToCheck: [Self]) -> Bool {
        guard cardsToCheck.count == SetGame.cardsToDealAndCheckCount else {return false}
      let signsSum = [
        cardsToCheck.reduce(0, { $0 + $1.firstSign.rawValue }),
        cardsToCheck.reduce(0, { $0 + $1.secondSign.rawValue }),
        cardsToCheck.reduce(0, { $0 + $1.thirdSign.rawValue }),
        cardsToCheck.reduce(0, { $0 + $1.fourthSign.rawValue })
      ]
        return signsSum.allSatisfy { $0 % 3 == 0 }
    }
}

enum Sign: Int, CaseIterable, CustomStringConvertible {
    case a = 1
    case b
    case c
    var i: Int { (self.rawValue - 1) }
    var description: String {
        switch self {
        case .a:
            return "a"
        case .b:
            return "b"
        case .c:
            return "c"
        }
    }
}
