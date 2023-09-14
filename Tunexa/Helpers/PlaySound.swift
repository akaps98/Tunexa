//
//  PlaySound.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import Foundation
import AVFoundation

class PlaySound: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0.0

    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    init(fileName: String, fileType: String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
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
}

