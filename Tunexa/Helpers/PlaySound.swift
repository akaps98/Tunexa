//
//  PlaySound.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import Foundation
import AVFoundation

class PlaySound: NSObject, ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0.0

    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
//    init(fileName: String = "", fileType: String = "", fileURL: String = "") {
//        super.init() // Add this line because we are now subclassing from NSObject
//        print("local")
//        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
//            let url = URL(fileURLWithPath: path)
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: url)
//                audioPlayer?.delegate = self  // Set the delegate here
//                audioPlayer?.prepareToPlay()
//                DispatchQueue.main.async {
//                    self.stop()
//                    self.play()
//                }
//            } catch {
//                print("Error loading audio file: \(error.localizedDescription)")
//            }
//        } else if let url = URL(string: fileURL){   // Get song url from the database if there is no local file for the song
//            do{
//                print("fetching")
//                URLSession.shared.dataTask(with: url){ (data, response, error) in
//                    guard let soundData = data else {return}
//                    do{
//                        self.audioPlayer = try AVAudioPlayer(data: soundData)
//                        self.audioPlayer?.delegate = self  // Set the delegate here
//                        self.audioPlayer?.prepareToPlay()
//                        DispatchQueue.main.async { // Play music when song is retrieved from the url
//                            self.stop()
//                            self.play()
//                        }
//                    }catch{
//                        print("Error loading audio file: \(error.localizedDescription)")
//                    }
//                }.resume()
//            }
//        }
//        else{
//            print("Audio file for \(fileName) not found.")
//        }
//    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
        startTimer()
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }

    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        currentTime = 0 // Reset playback to start
        stopTimer()
    }
    
    var duration: TimeInterval {
        return audioPlayer?.duration ?? 0
    }
    
    func setProgress(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.currentTime = self?.audioPlayer?.currentTime ?? 0
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func changeSong(fileName: String, fileType: String, fileURL: String, completion: @escaping () -> Void) {
        guard let url = URL(string: fileURL) else {
                print("Invalid URL: \(fileURL)")
                return
            }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching audio data: \(error.localizedDescription)")
                return
            }
            
            guard let soundData = data else {
                print("No audio data received.")
                return
            }
            
            do {
                self.audioPlayer = try AVAudioPlayer(data: soundData)
                self.audioPlayer?.delegate = self
                self.audioPlayer?.prepareToPlay()
                DispatchQueue.main.async {
                    self.stop()
                    self.play()
                    completion()
                }
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        }.resume()
    }
}

extension PlaySound: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player finished playing")
        if flag {
            NotificationCenter.default.post(name: .songDidFinishPlaying, object: nil)
        }
    }
}

extension Notification.Name {
    static let songDidFinishPlaying = Notification.Name("songDidFinishPlaying")
}
