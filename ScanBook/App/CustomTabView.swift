//
//  CustomTabView.swift
//  ScanBook
//
//  Created by 김학철 on 10/13/23.
//

import SwiftUI

struct CustomTabView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 8)
            
            HStack(alignment: .bottom) {
                Spacer()
                Button{
                    
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "house")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        Text("홈")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    VStack(spacing: 2) {
                        Color.green
                            .frame(width: 50, height: 50)
                            .overlay {
                                Image(systemName: "camera")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                        
                        
                        Text("Scan")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .foregroundColor(.green)
                        
                    }
                }
                Spacer()
                
                Button{
                    
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "person")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        Text("홈")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
        
            Spacer()
                .frame(height: 8)
                .safeAreaPadding(.bottom)
        }
        .frame(maxWidth: .infinity)
        .background(.primary10)
        .shadow(radius: 5)
        
    }
}

#Preview {
    CustomTabView()
        .environmentObject(AppStateVM())
}
