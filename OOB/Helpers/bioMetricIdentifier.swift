//
//  bioMetricIdentifier.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 10/03/21.
//  Copyright © 2021 Ephrim Daniel J. All rights reserved.
//

import Foundation
import LocalAuthentication


func biometricType() -> String {
    let authContext = LAContext()
    if #available(iOS 11, *) {
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return "none"
        case .touchID:
            return "touch"
        case .faceID:
            return "face"
        @unknown default:
            return "none"
        }
    } else {
        return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? "touch" : "none"
    }
}

enum BiometricType {
    case none
    case touch
    case face
}
