//
//  HomeView.swift
//  LoginScreen
//
//  Created by Sahil ChowKekar on 8/20/26.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.green)

            Text("Login Successful!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityIdentifier("loginSuccessMessage")

            Text("Welcome to the Home Screen.")
                .foregroundColor(.secondary)
        }
        .navigationTitle("Home")
    }
}

#Preview {
    HomeView()
}
