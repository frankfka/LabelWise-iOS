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
                    LabelScannerView()
                })
        }
    }
}
