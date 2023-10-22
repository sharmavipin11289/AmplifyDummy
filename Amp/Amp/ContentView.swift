//
//  ContentView.swift
//  Amp
//
//  Created by Vipin Sharma on 22/10/23.
//

import SwiftUI
import Amplify
import Zip

struct ContentView: View {
    @State var progress = 0.0
    @State var isDownloadStarted = false
    var body: some View {
        VStack {
            ZStack {
               // 2
                CircularProgressView(progress: progress)
               // 3
                Text((progress == 0.0) ? "↑" : (progress == 1.0) ? "✓" : "\(progress * 100, specifier: "%.0f")%")
                   .font(.body)
                   .bold()
           }.frame(width: 50, height: 50)
            .onTapGesture {
                if isDownloadStarted == false {
                    isDownloadStarted = true
                    Task {
                        do {
                            try await uploadFile()
                        } catch  {
                            print("ERROR:: \(error)")
                        }
                    }
                }else{
                    print("Do not panic In Download")
                }
                
            }
        }
        .padding()
    }
    
    //MARK: uploadFile
    func uploadFile() async throws {
        if let videoURL = Bundle.main.url(forResource: "BigBuckBunny", withExtension: "mp4") {
            
            do {
                let zipFilePath = try Zip.quickZipFiles([videoURL], fileName: "videoZip")
                print("ZIP CONVERTED::")
                
                let uploadTask = Amplify.Storage.uploadFile(
                    key: "Video_zip",
                    local: zipFilePath
                )

                Task {
                    for await progress in await uploadTask.progress {
                        print("Progress: \(progress)")
                        self.progress = progress.fractionCompleted
                    }
                }
                let data = try await uploadTask.value
                
            } catch {
                return
            }
        }
        
    }
    
    //MARK: upload Data
    func uploadData() async throws {
        guard let data = loadLocalVideoData() else {return}
        let uploadTask = Amplify.Storage.uploadData(
            key: "videoBikBunnyNew",
            data: data
        )
        Task {
            for await progress in await uploadTask.progress {
                print(progress.fractionCompleted)
                print("Progress: \(progress)")
                self.progress = progress.fractionCompleted
            }
        }
        let value = try await uploadTask.value
        print("Completed: \(value)")
    }
    
    //MARK: Load Local Video Data
    func loadLocalVideoData() -> Data? {
        
            if let videoURL = Bundle.main.url(forResource: "BigBuckBunny", withExtension: "mp4") {
                
                do {
                    let zipFilePath = try Zip.quickZipFiles([videoURL], fileName: "videoZip")
                    print("ZIP CONVERTED::")
                    if let zipFileData = try? Data(contentsOf: URL(fileURLWithPath: zipFilePath.path())) {
                        print("Zip to Data ::")
                        return zipFileData
                    }
                } catch {
                    return nil
                }
            }
            return nil
        }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
