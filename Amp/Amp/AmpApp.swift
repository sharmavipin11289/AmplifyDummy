//
//  AmpApp.swift
//  Amp
//
//  Created by Vipin Sharma on 22/10/23.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin

@main
struct AmpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
         configureAmplify()
       }
    
    func configureAmplify(){
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Amplify configured with Auth and Storage plugins :)")
        } catch {
            print("Failed to initialize Amplify with \(error) :(")
        }
    }
}
