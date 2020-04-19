import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State var isShowingCameraView = false
    
    var body: some View {
        VStack {
            Button(action : {
                print("Button Pressed")
                self.isShowingCameraView.toggle()
            }, label : {
                Text("Show Camera Preview")
            })
                .sheet(isPresented: $isShowingCameraView, content: {
                    CameraView()
                })
        }
    }
}

struct CameraView : UIViewControllerRepresentable {

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIViewController {
        let controller = CameraViewController()
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraView.UIViewControllerType, context: UIViewControllerRepresentableContext<CameraView>) {
        
    }
}

// My custom class which inits an AVSession for the live preview
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
