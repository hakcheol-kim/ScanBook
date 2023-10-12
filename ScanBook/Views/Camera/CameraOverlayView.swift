//
//  CameraOverlayView.swift
//  SUExamples
//
//  Created by 김학철 on 10/12/23.
//

import SwiftUI
import Combine

enum MarkLocation {
    case tl, tr, br, bl
}

struct Marker: Identifiable, Hashable, Equatable {
    var id: Int { hashValue }
    var originPoint: CGPoint
    var point: CGPoint
    
    init(originPoint: CGPoint, point: CGPoint = .zero) {
        self.originPoint = originPoint
        self.point = point
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(point.x)
        hasher.combine(point.y)
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
struct PointView: View {
    var point: CGPoint
    
    var body: some View {
        Circle()
            .frame(width: 20)
            .foregroundColor(.white)
            .position(x: point.x, y: point.y)
    }
}
struct LineShape: Shape, @unchecked Sendable {
    @Binding var tl: Marker
    @Binding var tr: Marker
    @Binding var br: Marker
    @Binding var bl: Marker
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: tl.point)
        path.addLine(to: tr.point)
        path.addLine(to: br.point)
        path.addLine(to: bl.point)
        path.closeSubpath()
        return path
    }
}
struct CameraOverlayView: View {
    
    @StateObject var vm = CameraOverlayView.ViewModel()
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.2)
            LineShape(tl: $vm.tl, tr: $vm.tr, br: $vm.br, bl: $vm.bl)
                .stroke(.red, lineWidth: 2)
            
            PointView(point: vm.tl.point)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let x = value.startLocation.x
                            let y = value.startLocation.y
                            let w = value.translation.width
                            let h = value.translation.height
                            let p = CGPoint(x: x+w, y: y+h)
                            vm.tl.point = p
                        }
                        .onEnded { value in
                            
                        }
                )
                .onChange(of: vm.tl) { oldValue, newValue in
                    var p = newValue.point
                    if p.x < 0 {
                        p.x = 0
                    }
                    else if p.x > vm.rectSize.width/2.0 {
                        p.x = vm.rectSize.width/2.0
                    }
                    
                    if p.y < 0 {
                        p.y = 0
                    } else if p.y > vm.rectSize.height/2 {
                        p.y = vm.rectSize.height/2
                    }
                    vm.tl.point = p
                }
            
            PointView(point: vm.tr.point)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let x = value.startLocation.x
                            let y = value.startLocation.y
                            let w = value.translation.width
                            let h = value.translation.height
                            vm.tr.point = CGPoint(x: x+w, y: y+h)
                        }
                        .onEnded { value in
                            
                        }
                )
                .onChange(of: vm.tr) { oldValue, newValue in
                    var p = newValue.point
                    if p.x < vm.rectSize.width/2 {
                        p.x = vm.rectSize.width/2
                    }
                    else if p.x > vm.rectSize.width {
                        p.x = vm.rectSize.width
                    }
                    
                    if p.y < 0 {
                        p.y = 0
                    }
                    else if p.y > vm.rectSize.height/2 {
                        p.y = vm.rectSize.height/2
                    }
                    vm.tr.point = p
                }
            
            PointView(point: vm.br.point)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let x = value.startLocation.x
                            let y = value.startLocation.y
                            let w = value.translation.width
                            let h = value.translation.height
                            vm.br.point = CGPoint(x: x+w, y: y+h)
                        }
                        .onEnded { value in
                            
                        }
                )
                .onChange(of: vm.br) { oldValue, newValue in
                    var p = newValue.point
                    if p.x < vm.rectSize.width/2 {
                        p.x = vm.rectSize.width/2
                    }
                    else if p.x > vm.rectSize.width {
                        p.x = vm.rectSize.width
                    }
                    
                    if p.y < vm.rectSize.height/2 {
                        p.y = vm.rectSize.height/2
                    }
                    else if p.y > vm.rectSize.height {
                        p.y = vm.rectSize.height
                    }
                    vm.br.point = p
                }
            
            PointView(point: vm.bl.point)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let x = value.startLocation.x
                            let y = value.startLocation.y
                            let w = value.translation.width
                            let h = value.translation.height
                            let p = CGPoint(x: x+w, y: y+h)
                            vm.bl.point = p
                        }
                        .onEnded { value in
                            
                        }
                )
                .onChange(of: vm.bl) { oldValue, newValue in
                    var p = newValue.point
                    if p.x < 0 {
                        p.x = 0
                    }
                    else if p.x > vm.rectSize.width/2.0 {
                        p.x = vm.rectSize.width/2.0
                    }
                    
                    if p.y < vm.rectSize.height/2 {
                        p.y = vm.rectSize.height/2
                    }
                    else if p.y > vm.rectSize.height {
                        p.y = vm.rectSize.height
                    }
                    vm.bl.point = p
                }
        }
        .overlay(
            GeometryReader { geo in
                Color.clear
                    .onAppear() {
                        let size = geo.size
                        vm.originSize = size
                        vm.rectSize = size
                        let p1: CGPoint = .init(x: 0, y: 0)
                        let p2: CGPoint = .init(x: size.width, y: 0)
                        let p3: CGPoint = .init(x: size.width, y: size.height)
                        let p4: CGPoint = .init(x: 0, y: size.height)
                        vm.tl = Marker(originPoint: p1, point: p1)
                        vm.tr = Marker(originPoint: p2, point: p2)
                        vm.br = Marker(originPoint: p3, point: p3)
                        vm.bl = Marker(originPoint: p4, point: p4)
                    }
            }
        )
    }
}

#Preview {
    CameraOverlayView()
}
extension CameraOverlayView {
    class ViewModel: ObservableObject {
        var cancelBag = Set<AnyCancellable>()
        @Published var tl: Marker = .init(originPoint: .zero)
        @Published var tr: Marker = .init(originPoint: .zero)
        @Published var br: Marker = .init(originPoint: .zero)
        @Published var bl: Marker = .init(originPoint: .zero)
        var padding: CGFloat = 20
        
        var rectSize: CGSize = .zero
        var originSize: CGSize = .zero
        init() {
            
        }
       
    }
}
