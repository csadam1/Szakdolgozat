//
//  Data.swift
//  chess-program
//
//  Created by Cseri Ádám on 2022. 05. 02..
//

import Foundation

enum GameStatus {
    case ACTIVE
    case DRAW
    case WHITE_WIN
    case BLACK_WIN
}

/* Extensions */

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
            let start = index(startIndex, offsetBy: max(0, range.lowerBound))
            let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                                 range.upperBound - range.lowerBound))
            return String(self[start..<end])
        }
}

extension Character {
    mutating func inc() -> Character {
        let optionalASCIIvalue = self.unicodeScalars.filter{$0.isASCII}.first?.value
        if let ASCIIvalue = optionalASCIIvalue {
            if let incrementedASCIIvalue = UnicodeScalar(ASCIIvalue+1) {
                self = Character(incrementedASCIIvalue)
            }
        }
        return self
    }
    mutating func dec() -> Character {
        let optionalASCIIvalue = self.unicodeScalars.filter{$0.isASCII}.first?.value
        if let ASCIIvalue = optionalASCIIvalue {
            if let incrementedASCIIvalue = UnicodeScalar(ASCIIvalue-1) {
                self = Character(incrementedASCIIvalue)
            }
        }
        return self
    }
}

extension Array {
    func findIndexNS(customArray: Array<Spot>) -> Int {
        let nestedArray = self
        for (index, array) in nestedArray.enumerated() {
            var ar = [Bool]()
            for (i, item) in (array as! Array<Spot>).enumerated() {
                ar.append(item === customArray[i])
            }
            if ar.allSatisfy({ $0 }) {
                return index
            }
        }
        return -1
    }
}

extension Piece {
    static func contains(array: Array<Piece.Type>, elem: Piece) -> Bool {
        return !array.filter { $0 == type(of: elem) }.isEmpty
    }
}

/* Constansts */

let RANKS = 8
let FILES = 8

let START_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
let CUSTOM_FEN_1 = "rnbqkbnr/pp1ppppp/2p5/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1"
let CUSTOM_FEN_2 = "rnbqkbnr/1p1ppp1p/8/8/2p3p1/p3P1P1/PPPP1P1P/RNBQKBNR w KQkq - 0 1"
let CUSTOM_FEN_3 = "rnbqkbnr/1pp2pp1/8/3Pp3/8/p3p2p/PPPPPPPP/RNBQKBNR w KQkq e6 0 1"
let CUSTOM_FEN_4 = "r2bkbn1/p1p1pp1p/8/4B3/8/2P5/P2PPPP1/1N1QKBNR w KQkq - 0 1"
let CUSTOM_FEN_5 = "3bkb2/p1p1ppn1/8/4B3/5p2/8/P2PPPP1/rNPQKBNR w KQkq - 0 1"
let CUSTOM_FEN_6 = "rnbk1bnr/pppppppp/8/8/1P2R3/8/PPPP1PPP/RNBK1BNR w KQkq - 0 1"
let CUSTOM_FEN_7 = "rnbk1bnr/pppppppp/8/8/1p2Rp2/8/PPPP1PPP/RNBKpBNR w KQkq - 0 1"
let CUSTOM_FEN_8 = "rnbqkbnr/pppppppp/8/8/N6N/8/P1PPPP1P/R1BQKB1R w KQkq - 0 1"
let CUSTOM_FEN_9 = "rnbqkbnr/p2ppp2/1p4p1/2p2p2/N6N/2P2P2/1P1PP1P1/R1BQKB1R w KQkq - 0 1"
let CUSTOM_FEN_10 = "pnb1kbn1/3ppppr/1p6/8/3Q4/8/RPPPPPPN/1NB1KB1R w KQkq - 0 1"
let CUSTOM_FEN_11 = "1nb1kbn1/3pppp1/1p6/8/1p1Q2r1/8/RPPPPPPN/1NB1KB1R w KQkq - 0 1"
let CUSTOM_FEN_12 = "rnbqkbnr/ppp1pppp/8/3p4/4K3/5P2/PPPPP1PP/RNBQ1BNR w KQkq - 0 1"
let CUSTOM_FEN_13 = "rnbqk1nr/p7/8/3ppp2/3pKp2/3bpp2/PPPPPPPP/RNBQ1BNR w KQkq - 0 1"
let CUSTOM_FEN_14 = "rnbqk1nr/p7/8/3ppp2/3pKp2/3bpp2/PPPPPPPP/RNBQ1BNR b KQkq - 0 1"
let CUSTOM_FEN_15 = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w kq - 0 1"
let CUSTOM_FEN_16 = "1nbqkbnr/pppppppp/6r1/8/8/8/P6P/R3K2R w KQkq - 0 1"
let CUSTOM_FEN_17 = "1nbqkbnr/pppppppp/5r2/8/8/8/P6P/R3K2R w KQkq - 0 1"
let CUSTOM_FEN_18 = "1nbqkbnr/pppppppp/1r6/8/8/8/P6P/R3K2R w KQkq - 0 1"
let CUSTOM_FEN_19 = "1nbqkbnr/pppppppp/2r5/8/8/8/P6P/R3K2R w KQkq - 0 1"
let CUSTOM_FEN_20 = "1nbqkbnr/pppppppp/3r4/8/8/8/P6P/R3K2R w KQkq - 0 1"
let CUSTOM_FEN_21 = "1nbqkbnr/pppppppp/4r3/8/8/8/P6P/R3K2R w KQkq - 0 1"
