//
//  MainView.swift
//  ScanBook
//
//  Created by 김학철 on 10/12/23.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var appState: AppStateVM
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationStack(path: $appState.rootNavi) {
            VStack {
                if appState.selectionTab == .home {
                    HomeView()
                        .frame(maxHeight: .infinity)
                }
                else if appState.selectionTab == .scan {
                    EmptyView()
                        .frame(maxHeight: .infinity)
                }
                else {
                    MoreView()
                        .frame(maxHeight: .infinity)
                }
                
                CustomTabView()
                    .frame(maxWidth: .infinity)
                    .environmentObject(appState)
                
            }
            .ignoresSafeArea()
            
//            TabView(selection: $appState.selectionTab) {
//                HomeView()
//                    .environmentObject(appState)
//                    .tabItem {
//                        Image(systemName: "house.fill")
//                            .resizable()
//                            .frame(width: 10, height: 10)
//                            .scaledToFit()
//                            .foregroundColor(appState.selectionTab == .home ? .blue : .gray)
//                            
//                        Text("홈")
//                            .font(.callout)
//                            .foregroundColor(appState.selectionTab == .home ? .blue : .gray)
//                    }
//                
//                CameraView()
//                    .environmentObject(appState)
//                    .tabItem {
//                        Image(systemName: "hous")
//                            .foregroundColor(appState.selectionTab == .home ? .blue : .gray)
//                        Text("홈")
//                            .font(.callout)
//                            .foregroundColor(appState.selectionTab == .home ? .blue : .gray)
//                    }
//                
//                MoreView()
//                    .environmentObject(appState)
//                    .tabItem {
//                        Image(systemName: "home")
//                            .foregroundColor(appState.selectionTab == .home ? .blue : .gray)
//                        Text("홈")
//                            .font(.callout)
//                            .foregroundColor(appState.selectionTab == .home ? .blue : .gray)
//                    }
//            }
//                List {
//                    ForEach(items) { item in
//                        NavigationLink {
//                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                        } label: {
//                            Text(item.timestamp!, formatter: itemFormatter)
//                        }
//                    }
//                    .onDelete(perform: deleteItems)
//                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        EditButton()
//                    }
//                    ToolbarItem {
//                        Button(action: addItem) {
//                            Label("Add Item", systemImage: "plus")
//                        }
//                    }
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            
//                        } label: {
//                            Label("Scan", systemImage: "camera")
//                        }
//                        
//                    }
//                }
//                Text("Select an item")
//            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AppStateVM())
}

