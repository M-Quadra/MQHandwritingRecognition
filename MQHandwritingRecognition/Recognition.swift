//
//  Recognition.swift
//  MQHandwritingRecognition
//
//  Created by m_quadra on 2022/8/25.
//

import UIKit
import MQKit


public func byRecognition(strokes: [[CGPoint]]) async -> [String] {
    let strokes = Util.normalize(strokes: strokes)
    if strokes.isEmpty { return [] }
    
    let wordImg = Util.renderWordImage(strokes: strokes)
    
    let size = CGSize(
        width: Config.edge * 6,
        height: Config.edge
    )
    let img = UIImage.render(
        size: size,
        opaque: true,
        scale: 1
    ) { ctx in
        ctx.setFillColor(.white)
        ctx.fill(CGRect(origin: .zero, size: size))
        
        for i in 0..<3 {
            wordImg.draw(at: CGPoint(
                x: CGFloat(i)*Config.edge + Config.padding,
                y: Config.padding
            ))
        }
        
        for (i, v) in Config.suffixArr.enumerated() {
            let attStr = NSAttributedString(string: v, attributes: [
                .font: UIFont.systemFont(ofSize: Config.edge - Config.padding*2)
            ])
            attStr.draw(at: CGPoint(
                x: CGFloat(i+3)*Config.edge + Config.padding,
                y: Config.padding
            ))
        }
    }
    
    return Util.inference(image: img)
}
