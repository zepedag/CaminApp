import Combine
import SwiftUI
import AVFoundation

class CameraPermissionHandler: ObservableObject {
    @Published var hasCameraPermission: Bool = false

    init() {
        checkCameraAccess { granted in
            DispatchQueue.main.async {
                self.hasCameraPermission = granted
            }
        }
    }

    private func checkCameraAccess(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: completion)
        default:
            completion(false)
        }
    }
}
