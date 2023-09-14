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
    
    init(fileName: String, fileType: String) {
        super.init() // Add this line because we are now subclassing from NSObject

        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self  // Set the delegate here
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        } else {
            print("Audio file \(fileName).\(fileType) not found.")
        }
    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
        startTimer()
        audioPlayer?.delegate = self
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }

    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        audioPlayer?.currentTime = 0 // Reset playback to start
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
    
    func changeSong(fileName: String, fileType: String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self // Make sure to set the delegate for new song as well
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error changing to new song: \(error.localizedDescription)")
            }
        }
    }
}

extension PlaySound: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            NotificationCenter.default.post(name: .songDidFinishPlaying, object: nil)
        }
    }
}

extension Notification.Name {
    static let songDidFinishPlaying = Notification.Name("songDidFinishPlaying")
}
