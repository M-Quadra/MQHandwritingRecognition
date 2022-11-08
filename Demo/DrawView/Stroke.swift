//
//  Stroke.swift
//  Demo
//
//  Created by m_quadra on 2022/8/25.
//

import UIKit
import MQKit

extension DrawView {
    
    class Stroke {
        
        var points = [CGPoint]()
        let path = UIBezierPath()
        let layer = dsl(for: CAShapeLayer.self) { make in
            make.fillColor(.clear)
                .strokeColor(.black)
                .lineWidth(3)
                .lineJoin(.round)
                .lineCap(.round)
        }
        
        required init(_ startPoint: CGPoint) {
            self.path.move(to: startPoint)
            self.append(startPoint)
        }
        
        func append(_ point: CGPoint) {
            self.points.append(point)
            self.path.addLine(to: point)
            self.layer.path = self.path.cgPath
        }
    }
}
