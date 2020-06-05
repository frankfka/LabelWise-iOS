//
// Created by Frank Jia on 2020-06-04.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import AVFoundation

protocol DeviceService {
    func didCompleteOnboarding() -> Bool
    func completedOnboarding()
    func checkAndPromptForCameraPermission() -> ServicePublisher<Bool>
}

class DeviceServiceImpl: DeviceService {
    private static let OnboardingUDKey = "OnboardingComplete"

    // MARK: Onboarding user defaults
    func didCompleteOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: DeviceServiceImpl.OnboardingUDKey)
    }

    func completedOnboarding() {
        UserDefaults.standard.set(true, forKey: DeviceServiceImpl.OnboardingUDKey)
    }

    // MARK: Camera permission
    func checkAndPromptForCameraPermission() -> ServicePublisher<Bool> {
        ServiceFuture<Bool> { promise in
            AVCaptureDevice.requestAccess(for: .video) { hasPermission in
                promise(.success(hasPermission))
            }
        }.eraseToAnyPublisher()
    }


}