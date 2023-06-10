//
//  extension.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import Foundation
import SwiftUI
import AVFoundation

extension AVPlayer {
    
    static var queuePlayer = AVQueuePlayer()

    static var playerLooper: AVPlayerLooper!
    
    static func playFirstQuarter() {
        queuePlayer.removeAllItems()
        guard let Url = Bundle.main.url(forResource: "First Quarter", withExtension: "mp3") else{fatalError("Failed to fin sound file.")}
        let item = AVPlayerItem(url: Url)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        queuePlayer.play()
    }
}

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}
