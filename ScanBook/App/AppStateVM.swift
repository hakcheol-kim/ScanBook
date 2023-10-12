//
//  AppStateVM.swift
//  ScanBook
//
//  Created by 김학철 on 10/12/23.
//

import SwiftUI
import Combine
enum MainTab {
    case home, scan, more
}
class AppStateVM: ObservableObject {
    
    @Published var rootNavi = NavigationPath()
    @Published var selectionTab: MainTab = .home
    
    func resetRootNavipath() {
        self.rootNavi = NavigationPath()
    }
}

