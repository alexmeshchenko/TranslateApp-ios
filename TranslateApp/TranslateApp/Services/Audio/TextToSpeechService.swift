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
        // Настройка аудио сессии
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func playFromURL(_ urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        
        player?.pause()
        player = AVPlayer(url: url)
        player?.play()
        
        // looking forward to the end of pyaying
        if let duration = player?.currentItem?.asset.duration {
            let seconds = CMTimeGetSeconds(duration)
            if seconds.isFinite && seconds > 0 {
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            }
        }
    }
    
    func stop() {
        player?.pause()
        player = nil
    }
}
