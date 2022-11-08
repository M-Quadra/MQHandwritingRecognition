//
//  Util.swift
//  MQHandwritingRecognition
//
//  Created by m_quadra on 2022/9/22.
//

import UIKit
import MQKit
import Vision

struct Util {
    
    static func normalize(strokes: [[CGPoint]]) -> [[CGPoint]] {
        if strokes.isEmpty || strokes[0].isEmpty { return [] }

        let arr = strokes.flatMap { $0 }
        let minXY = arr.reduce(arr[0]) {
            CGPoint(x: min($0.x, $1.x), y: min($0.y, $1.y))
        }
        let maxXY = arr.reduce(arr[0]) {
            CGPoint(x: max($0.x, $1.x), y: max($0.y, $1.y))
        }
        
        let center = CGPoint(x: (minXY.x + maxXY.x) / 2, y: (minXY.y + maxXY.y) / 2)
        let edge = max(maxXY.x - minXY.x, maxXY.y - minXY.y)
        let scale = edge > 1 ? (Config.edge - Config.padding*2) / edge : 1
        let offset = CGPoint(edge/2) - center
        
        return strokes.map { stroke in
            stroke.map { point in
                (point + offset) * scale
            }
        }
    }
    
    static func renderWordImage(strokes: [[CGPoint]]) -> UIImage {
        let path = UIBezierPath()
        for stroke in strokes {
            guard let first = stroke.first else { continue }
            path.move(to: first)
            
            for point in stroke {
                path.addLine(to: point)
            }
        }
        
        let layer: CAShapeLayer = dsl { make in
            make.size(Config.edge - Config.padding*2)
                .fillColor(.clear)
                .strokeColor(.black)
                .lineWidth(Config.lineWidth)
                .lineJoin(.round)
                .lineCap(.round)
                .path(path)
        }
        return UIImage.layer(layer, scale: 1)
    }
    
    static func inference(image: UIImage) -> [String] {
        guard let cgImg = image.cgImage else { return [] }
        
        let req = VNRecognizeTextRequest()
        req.revision = VNRecognizeTextRequestRevision2
        req.recognitionLanguages = ["zh-Hans", "zh-Hant"]
        req.recognitionLevel = .accurate
        req.usesLanguageCorrection = true
        
        do {
            let handler = VNImageRequestHandler(cgImage: cgImg)
            try handler.perform([req])
        } catch {
            return []
        }
        guard let results = req.results else { return [] }
        
        var preSet = Set(Config.suffixArr)
        var uniSet = Set<String>()
        
        return results.compactMap { obs -> String? in
            guard let top = obs.topCandidates(1).first else { return nil }
            return top.string
        }.joined().map { char in
            let str = String(char).trimmingCharacters(in: .whitespacesAndNewlines)
            return Config.convDic[str] ?? str
        }.filter { str in
            guard !str.isEmpty,
                  preSet.remove(str) == nil,
                  !uniSet.contains(str)
            else { return false }
            
            uniSet.insert(str)
            return true
        }.reversed()
    }
}
