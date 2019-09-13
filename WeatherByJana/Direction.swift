//
//  Direction.swift
//  WeatherByJana
//
//  Created by Jana Beth Hart on 6/19/19.
//

import Foundation

enum Direction: String
{
    case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw
}

extension Direction: CustomStringConvertible
{
    static let all: [Direction] = [.n, .nne, .ne, .ene, .e, .ese, .se, .sse, .s, .ssw, .sw, .wsw, .w, .wnw, .nw, .nnw]
    
    init(_ direction: Double)
    {
        let index = Int((direction + 11.25).truncatingRemainder(dividingBy: 360) / 22.5)
        self = Direction.all[index]
    }
    
    var description: String
    {
        return rawValue.uppercased()
    }
}

extension Double
{
    var direction: Direction
    {
        return Direction(self)
    }
}

