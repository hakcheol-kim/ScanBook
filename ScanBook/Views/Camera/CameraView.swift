//
//  CameraView.swift
//  SUExamples
//
//  Created by 김학철 on 10/11/23.
//

import SwiftUI
import Combine


struct CameraView: View {
    
    @StateObject var carmeraVm = CameraModel()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            
            if let image = carmeraVm.image {
                GeometryReader { geo in
                Image(decorative: image, scale: 1.0, orientation: .up)
                    .resizable()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .scaledToFit()
                    .overlay {
                        CameraOverlayView()
                    }
                }
                    
            }
        }
        .ignoresSafeArea()
        .onChange(of: carmeraVm.cameraPermissionAlert) { oldValue, newValue in
            
        }
        .onAppear {
            carmeraVm.checkPermission()
        }
        
    }
    
}
#Preview {
    CameraView()
}
