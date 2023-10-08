//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.


import SwiftUI

struct NavigationBar: View {
    @Binding var searchText: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18).weight(.medium))
                        .foregroundColor(Color.basalt)
                        .frame(maxWidth: 40, maxHeight: 40, alignment: .leading)
                }

                Text("지역 추가하기")
                    .font(.system(size: 18).weight(.semibold))
                    .foregroundColor(Color.darkChacoal)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                Text("편집")
                    .font(.system(size: 18).weight(.semibold))
                    .foregroundColor(Color.darkChacoal)
                    .frame(maxWidth: 40, maxHeight: 40, alignment: .trailing)
            }

            searchBar

        }
        .frame(height: 106, alignment: .top)
        .padding(.horizontal, 20)
        .padding(.top, 64)
        .background(Color.seaSky)
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }

    private var searchBar: some View {
        HStack(spacing: 2) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.darkChacoal)

            TextField("title", text: $searchText, prompt: Text("지역 검색하기").foregroundColor(Color.darkChacoal))
                .font(.system(size: 18))

        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 6)
        .padding(.vertical, 28)
        .frame(maxHeight: 45, alignment: .leading)
        .background(Color.seaSky, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.darkChacoal, lineWidth: 2))
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(searchText: .constant(""))
    }
}
