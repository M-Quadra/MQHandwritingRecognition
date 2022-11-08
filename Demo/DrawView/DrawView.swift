//
//  DrawView.swift
//  Demo
//
//  Created by m_quadra on 2022/8/25.
//

import UIKit

class DrawView: UIScrollView {

    override var isScrollEnabled: Bool {
        get {
            return false
        }
        set {}
    }
    
    var lineWidth: CGFloat = 16
    var lineColor: UIColor = .gray
    var strokes = [DrawView.Stroke]()
    
    private var _strokesDidChange: ((_ strokes: [[CGPoint]]) -> Void)?
    func strokesDidChange(closure: @escaping (_ strokes: [[CGPoint]]) -> Void) {
        _strokesDidChange = closure
    }
}

// MARK: - Touches
extension DrawView {
    
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        return event?.allTouches?.count == 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if event?.allTouches?.count != 1 { return }
        
        guard let point = touches.first?.location(in: self) else { return }
        let stroke = DrawView.Stroke(point)
        
        self.layer.addSublayer(stroke.layer)
        self.strokes.append(stroke)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if event?.allTouches?.count != 1 { return }
        
        guard let point = touches.first?.location(in: self) else { return }
        guard let last = self.strokes.last else { return }
        last.append(point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if event?.allTouches?.count != 1 { return }
        
        guard let didChange = self._strokesDidChange else { return }
        let arr = self.strokes.map { $0.points }
        didChange(arr)
    }
}

// MARK: - Pubilc
extension DrawView {
    
    func reset() {
        for stroke in self.strokes {
            stroke.layer.removeFromSuperlayer()
        }
        self.strokes.removeAll()
    }
}
