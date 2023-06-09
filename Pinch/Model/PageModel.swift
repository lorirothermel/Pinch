//
//  PageModel.swift
//  Pinch
//
//  Created by Lori Rothermel on 6/8/23.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
