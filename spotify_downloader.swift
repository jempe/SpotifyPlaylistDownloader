import Foundation
import SwiftSoup

// Replace with your own Spotify user ID
let userId = "YOUR_USER_ID"

func getPlaylists() -> [(String, String)] {
    let playlistUrl = URL(string: "https://open.spotify.com/user/\(userId)/playlists")!
    let html = try! String(contentsOf: playlistUrl, encoding: .utf8)
    let doc = try! SwiftSoup.parse(html)
    let playlistElements = try! doc.select(".mo-info-name")
    return playlistElements.map { (try! $0.text(), try! $0.parent()!.attr("href")) }
}

func getTracks(playlistId: String) -> [(String, String)] {
    let playlistUrl = URL(string: "https://open.spotify.com/\(playlistId)")!
    let html = try! String(contentsOf: playlistUrl, encoding: .utf8)
    let doc = try! SwiftSoup.parse(html)
    let trackElements = try! doc.select(".track-name")
    let artistElements = try! doc.select(".artists-albums a")
    return trackElements.zip(artistElements).map { (try! $0.0.text(), try! $0.1.text()) }
}

func saveAsCSV(playlists: [(String, String)]) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
    let dateStr = dateFormatter.string(from: Date())
    let filename = "spotify_playlists_\(dateStr).csv"
    let csvString = playlists.map { "\($0.0),\($0.1)" }.joined(separator: "\n")
    try! csvString.write(toFile: filename, atomically: true, encoding: .utf8)
}

let playlists = getPlaylists()
let tracks = playlists.flatMap { getTracks(playlistId: $0.1) }
let allTracks = Array(Set(tracks))
saveAsCSV(playlists: allTracks)

