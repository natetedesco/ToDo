//
//  Helpers.swift
//  ToDo
//  Created by Developer on 10/6/24.
//

import Foundation
import SwiftUI

let listIcons = [
    "list.bullet",
    "checklist",
    "checkmark.circle.fill",
    "calendar",
    "clock.fill",
    "flag.fill",
    "star.fill",
    "tag.fill",
    "bookmark.fill",
    "pencil",
    "doc.text.fill",
    "folder.fill",
    "tray.fill",
    "archivebox.fill",
    "paperclip",
    "link",
    "bell.fill",
    "person.fill",
    "person.2.fill",
    "briefcase.fill",
    "house.fill",
    "cart.fill",
    "bag.fill",
    "creditcard.fill",
    "dollarsign.circle.fill",
    "gift.fill",
    "heart.fill",
    "book.fill",
    "graduationcap.fill",
    "gamecontroller.fill",
    "music.note",
    "movie.fill",
    "airplane",
    "car.fill",
    "bicycle",
    "figure.walk",
    "fork.knife",
    "cup.and.saucer.fill",
    "bed.double.fill",
    "phone.fill",
    "envelope.fill",
    "message.fill",
    "map.fill",
    "pawprint.fill",
    "leaf.fill",
    "flame.fill",
    "bolt.fill",
    "hammer.fill",
    "screwdriver.fill",
    "wrench.fill",
    "scissors",
    "paintbrush.fill",
    "camera.fill",
    "photo.fill",
    "trash.fill",
    "folder.badge.plus",
    "doc.badge.plus",
    "note.text",
    "text.bubble.fill",
    "hand.thumbsup.fill",
    "hand.raised.fill",
    "brain.head.profile",
    "pill.fill",
    "cross.case.fill",
    "gym.bag.fill",
    "suitcase.fill",
    "globe"
]

let colorChoices: [Color] = [
    .red,
    .orange,
    .yellow,
    .green,
    .mint,
    .teal,
    .cyan,
    .blue,
    .indigo,
    .purple,
    .pink,
    .brown,
    .gray,
    Color(red: 0.9, green: 0.3, blue: 0.3),  // Less saturated Red
    Color(red: 0.9, green: 0.7, blue: 0.4),  // Less saturated Orange
    Color(red: 0.9, green: 0.9, blue: 0.4),  // Less saturated Yellow
    Color(red: 0.4, green: 0.9, blue: 0.4),  // Less saturated Green
    Color(red: 0.5, green: 0.9, blue: 0.8),  // Less saturated Mint
    Color(red: 0.4, green: 0.7, blue: 0.7),  // Less saturated Teal
    Color(red: 0.4, green: 0.9, blue: 0.9),  // Less saturated Cyan
    Color(red: 0.3, green: 0.3, blue: 0.9),  // Less saturated Blue
    Color(red: 0.5, green: 0.3, blue: 0.7),  // Less saturated Indigo
    Color(red: 0.7, green: 0.3, blue: 0.7),  // Less saturated Purple
    Color(red: 0.9, green: 0.7, blue: 0.75), // Less saturated Pink
    Color(red: 0.7, green: 0.6, blue: 0.5),  // Less saturated Brown
    Color(red: 0.6, green: 0.6, blue: 0.6)   // Less saturated Gray
]

func lightHaptic() {
    let impactLit = UIImpactFeedbackGenerator(style: .light)
    impactLit.impactOccurred()
}

func medHaptic() {
    let impactLit = UIImpactFeedbackGenerator(style: .medium)
    impactLit.impactOccurred()
}

func softHaptic() {
    let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    impactSoft.impactOccurred()
}
