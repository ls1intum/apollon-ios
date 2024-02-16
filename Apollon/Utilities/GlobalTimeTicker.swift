//
//  GlobalTimeTicker.swift
//  Apollon
//
//  Created by Andrew Koo on 2/16/24.
//

import Foundation
import Combine

class GlobalTimeTicker: ObservableObject {
    @Published var tick = false
    private var timerSubscription: AnyCancellable?

    init() {
        timerSubscription = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick.toggle()
            }
    }
}
