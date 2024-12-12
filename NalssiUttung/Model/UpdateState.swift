//
//  UpdateState.swift
//  NalssiUttung
//
//  Created by 금가경 on 12/12/24.
//

actor UpdateState {
    private(set) var isUpdating: Bool = false
    
    func startUpdating() -> Bool {
        guard !isUpdating else { return false }
        isUpdating = true
        return true
    }
    
    func stopUpdating() {
        isUpdating = false
    }
}
