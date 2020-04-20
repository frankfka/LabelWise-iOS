//
// Created by Frank Jia on 2020-04-19.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI


struct CameraView : UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIViewController {
        let controller = CameraViewController()
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraView.UIViewControllerType,
                                context: UIViewControllerRepresentableContext<CameraView>) {

    }
}


class CameraViewController : UIViewController {

    private var cameraController: CameraController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCamera()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cameraController?.stopSession()
    }

    private func loadCamera() {
        let cameraController = CameraController()
        view.contentMode = UIView.ContentMode.scaleAspectFit
        cameraController.startSession { [weak self] err in
            guard err == nil else {
                // TODO: Logging
                return
            }
            guard let v = self?.view else {
                // TODO: logging
                return
            }
            if let err = cameraController.displayPreview(on: v) {
                print(err)
            }
            print("Init success")
        }
        self.cameraController = cameraController
    }
}
