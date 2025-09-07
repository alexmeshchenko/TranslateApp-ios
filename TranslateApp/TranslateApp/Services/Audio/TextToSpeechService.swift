//
//  TextToSpeechService.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 06.09.25.
//


import AVFoundation

@MainActor
final class TextToSpeechService {
    static let shared = TextToSpeechService()
    private var player: AVPlayer?
    
    private init() {
        // Setting up audio session
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func playFromURL(_ urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        
        player?.pause()
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        
        // Waiting for loading 'duration' for iOS 16+
        do {
            let duration = try await playerItem.asset.load(.duration)
            let seconds = CMTimeGetSeconds(duration)
            
            if seconds.isFinite && seconds > 0 {
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            } else {
                // Fallback - wait for a fixed time if 'duration' is not available
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        } catch {
            // If 'duration' failed to load, use fixed delay
            print("⚠️ Could not load audio duration: \(error)")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }
    
    func stop() {
        player?.pause()
        player = nil
    }
}
