//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Brett Giles on 2016-01-02.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import Foundation
class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
