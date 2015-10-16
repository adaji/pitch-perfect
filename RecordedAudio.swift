//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ada Ji on 10/8/15.
//  Copyright © 2015 Ada Ji. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!

    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}

