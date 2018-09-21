//
//  JHAnnunciator.swift
//  JustHelp
//
//  Created by LongFan on 2018/9/3.
//  Copyright © 2018 Long Fan. All rights reserved.
//

import UIKit

class JHAnnunciator: NSObject {
    
    public func sos(_ params: NSDictionary) -> String {
        return """
        报警，我在网约车上遇到危险，\(params["carColor"] ?? "")颜色的\(params["carBrand"] ?? "")车，车牌号\(params["plateNumber"] ?? "")
        从\(params["from"] ?? "")开往\(params["to"] ?? "")。
        """
    }

}
