//
//  Config.swift
//  MQHandwritingRecognition
//
//  Created by m_quadra on 2022/8/25.
//

import UIKit

public struct Config {
    
    public static var edge: CGFloat = 200
    public static var padding: CGFloat = 20
    public static var lineWidth: CGFloat = 12
    
    public static var suffixArr = ["一", "三", "五"]
    public static var convDic = [
        "-": "一",
        "—": "一",
        "=": "二",
        "•": "",
    ]
}
