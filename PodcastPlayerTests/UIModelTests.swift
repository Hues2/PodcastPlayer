//
//  UIModelTests.swift
//  PodcastPlayerTests
//

import Testing
import Foundation
@testable import PodcastPlayer

// MARK: - PodcastUIModel Tests

@Suite("PodcastUIModel")
struct PodcastUIModelTests {

    @Test func initWithFullDTO() {
        let dto = PodcastDTO(
            author: "Author", categoryIds: [1, 2], description: "A podcast",
            id: 42, image: "abc123", languageIso: "en", link: "https://example.com",
            original: true, popularity: 95.5, rss: "https://example.com/rss",
            seasonal: true, slug: "test-slug", title: "Test Podcast", type: "episodic"
        )

        let model = PodcastUIModel(dto)

        #expect(model != nil)
        #expect(model?.id == 42)
        #expect(model?.title == "Test Podcast")
        #expect(model?.author == "Author")
        #expect(model?.categoryIds == [1, 2])
        #expect(model?.description == "A podcast")
        #expect(model?.imageURL?.absoluteString.contains("abc123") == true)
        #expect(model?.languageIso == "en")
        #expect(model?.link == "https://example.com")
        #expect(model?.popularity == 95.5)
        #expect(model?.rss == "https://example.com/rss")
        #expect(model?.seasonal == true)
        #expect(model?.type == "episodic")
    }

    @Test func initReturnsNilWhenIdIsNil() {
        let dto = PodcastDTO(
            author: nil, categoryIds: nil, description: nil,
            id: nil, image: nil, languageIso: nil, link: nil,
            original: nil, popularity: nil, rss: nil,
            seasonal: nil, slug: nil, title: nil, type: nil
        )

        #expect(PodcastUIModel(dto) == nil)
    }

    @Test func initDefaultsForNilFields() {
        let dto = PodcastDTO(
            author: nil, categoryIds: nil, description: nil,
            id: 1, image: nil, languageIso: nil, link: nil,
            original: nil, popularity: nil, rss: nil,
            seasonal: nil, slug: nil, title: nil, type: nil
        )

        let model = PodcastUIModel(dto)

        #expect(model?.title == "Unknown Podcast")
        #expect(model?.popularity == 0)
        #expect(model?.seasonal == false)
        #expect(model?.imageURL == nil)
    }

    @Test func initImageURLIsNilWhenImageIdIsNil() {
        let dto = PodcastDTO(
            author: nil, categoryIds: nil, description: nil,
            id: 1, image: nil, languageIso: nil, link: nil,
            original: nil, popularity: nil, rss: nil,
            seasonal: nil, slug: nil, title: "Test", type: nil
        )

        #expect(PodcastUIModel(dto)?.imageURL == nil)
    }

    @Test func initFromSinglePodcastDTO() {
        let podcastDTO = PodcastDTO(
            author: "Author", categoryIds: nil, description: nil,
            id: 10, image: nil, languageIso: nil, link: nil,
            original: nil, popularity: nil, rss: nil,
            seasonal: nil, slug: nil, title: "From Single", type: nil
        )
        let singleDTO = SinglePodcastDTO(podcast: podcastDTO)

        let model = PodcastUIModel(singleDTO)

        #expect(model?.id == 10)
        #expect(model?.title == "From Single")
    }

    @Test func initFromSinglePodcastDTOReturnsNilWhenPodcastIsNil() {
        let singleDTO = SinglePodcastDTO(podcast: nil)
        #expect(PodcastUIModel(singleDTO) == nil)
    }
}

// MARK: - EpisodeUIModel Tests

@Suite("EpisodeUIModel")
struct EpisodeUIModelTests {

    @Test func initWithFullDTO() {
        let dto = EpisodeDTO(
            id: 99, title: "Episode 1", description: "First episode",
            duration: 3600, encoded: nil, episode: 1, exclusive: false,
            mimeType: "audio/mpeg", podcastId: 42, published: 1700000000,
            season: 2, slug: "ep-1", type: "full",
            url: "https://example.com/episode.mp3"
        )

        let model = EpisodeUIModel(dto)

        #expect(model != nil)
        #expect(model?.id == 99)
        #expect(model?.title == "Episode 1")
        #expect(model?.description == "First episode")
        #expect(model?.duration == 3600)
        #expect(model?.episode == 1)
        #expect(model?.season == 2)
        #expect(model?.type == "full")
        #expect(model?.published != nil)
        #expect(model?.audioURL?.absoluteString == "https://example.com/episode.mp3")
    }

    @Test func initReturnsNilWhenIdIsNil() {
        let dto = EpisodeDTO(
            id: nil, title: nil, description: nil,
            duration: nil, encoded: nil, episode: nil, exclusive: nil,
            mimeType: nil, podcastId: nil, published: nil,
            season: nil, slug: nil, type: nil, url: nil
        )

        #expect(EpisodeUIModel(dto) == nil)
    }

    @Test func initDefaultsForNilFields() {
        let dto = EpisodeDTO(
            id: 1, title: nil, description: nil,
            duration: nil, encoded: nil, episode: nil, exclusive: nil,
            mimeType: nil, podcastId: nil, published: nil,
            season: nil, slug: nil, type: nil, url: nil
        )

        let model = EpisodeUIModel(dto)

        #expect(model?.title == "Unknown Episode")
        #expect(model?.published == nil)
        #expect(model?.audioURL == nil)
    }

    @Test func initConvertsPublishedTimestamp() {
        let timestamp = 1700000000
        let dto = EpisodeDTO(
            id: 1, title: "Test", description: nil,
            duration: nil, encoded: nil, episode: nil, exclusive: nil,
            mimeType: nil, podcastId: nil, published: timestamp,
            season: nil, slug: nil, type: nil, url: nil
        )

        let model = EpisodeUIModel(dto)
        let expectedDate = Date(timeIntervalSince1970: TimeInterval(timestamp))

        #expect(model?.published == expectedDate)
    }

    @Test func initAudioURLIsNilWhenUrlIsNil() {
        let dto = EpisodeDTO(
            id: 1, title: "Test", description: nil,
            duration: nil, encoded: nil, episode: nil, exclusive: nil,
            mimeType: nil, podcastId: nil, published: nil,
            season: nil, slug: nil, type: nil, url: nil
        )

        #expect(EpisodeUIModel(dto)?.audioURL == nil)
    }
}
