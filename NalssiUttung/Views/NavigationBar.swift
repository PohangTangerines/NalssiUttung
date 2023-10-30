//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.


import SwiftUI

struct NavigationBar: View {
    @Binding var searchText: String
    @Binding var isEditMode: Bool
    @Binding var isTextFieldActive: Bool
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    
//    @State private var items: [String] = []
    @ObservedObject var userLocationList = UserLocationList()
    let locations = LocationInfo.Data.map { $0.location }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18).weight(.medium))
                        .foregroundColor(Color.basalt)
                        .frame(maxWidth: 40, maxHeight: 40, alignment: .leading)
                }

                Text("지역 추가하기")
                    .font(.system(size: 18).weight(.semibold))
                    .foregroundColor(Color.darkChacoal)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                Button(action: {
                    userLocationList.saveItems()
                    withAnimation {
                        self.isEditMode.toggle() // 편집 모드를 토글합니다.
                    }
                }) {
                    Text(isEditMode ? "완료" : "편집")
                        .font(.system(size: 18).weight(.semibold))
                        .foregroundColor(Color.darkChacoal)
                        .frame(maxWidth: 40, maxHeight: 40, alignment: .trailing)
                }
            }

            searchBar

        }
        .frame(height: 106, alignment: .top)
        .padding(.horizontal, 20)
        .padding(.top, 64)
        .background(Color.seaSky)
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        
    }

    private var searchBar: some View {
        HStack {
            HStack(spacing: 2) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.darkChacoal)

                TextField("title", text: $searchText, prompt: Text("지역 검색하기").foregroundColor(Color.darkChacoal))
                    .font(.system(size: 18))
                    .focused($isFocused)

            }
            .foregroundColor(.secondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 28)
            .frame(maxHeight: 45, alignment: .leading)
            .background(Color.seaSky, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.darkChacoal, lineWidth: 2))
            .onTapGesture {
                withAnimation {
                    isTextFieldActive = true
                }
            }

            if isTextFieldActive {
                Button(action: {
                    isFocused = false
                    isTextFieldActive.toggle()
                    searchText = ""
                }, label: {
                    Text("취소")
                        .font(.system(size: 18).weight(.semibold))
                        .foregroundColor(Color.darkChacoal)
                        .frame(maxWidth: 40, maxHeight: 40, alignment: .trailing)
                })

            }
        }
    }
    
//    func saveModifiedItems() {
//        UserDefaults.standard.set(items, forKey: "items")
////        isEditMode.toggle()
//    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(searchText: .constant(""), isEditMode: .constant(false), isTextFieldActive: .constant(false))
    }
}
