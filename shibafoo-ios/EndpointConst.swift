//
//  EndpointConst.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2016/11/13.
//  Copyright © 2016年 mo-fu. All rights reserved.
//

import Foundation

class EndpointConst : NSObject {
    /* shibafoo API URLs */
    #if DEBUG
    // let URL = "http://localhost:3000/"
    let URL = "https://shibafoo-shibafoo.sqale.jp/"
    #elseif STAGING
    let URL = "http://shibafoo-staging-shibafoo.sqale.jp/"
    #else
    let URL = "https://shibafoo-shibafoo.sqale.jp/"
    #endif
}
