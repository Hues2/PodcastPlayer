# PodcastPlayer

PodcastPlayer is an iOS tech task project built in SwiftUI. It presents a curated podcast list, drills into podcast details and episodes, and supports episode playback with compact and expanded now-playing experiences.

## Task Mapping

This implementation covers the requested brief with:

- A `Podcast List` screen that fetches podcasts from `https://the-podcasts.fly.dev/v1/`
- A `Podcast Detail / Episode List` screen that loads episodes for the selected podcast
- Tap-to-play episode playback
- A compact now-playing bar plus an expanded player with play/pause, seek, skip forward, and skip backward controls
- Loading, retry, and error states for podcast and episode fetches
- Basic playback error handling for invalid or missing episode audio URLs
- Modular SwiftUI + MVVM structure with unit tests for core behavior

## Features

- Featured podcast header on the home screen
- Horizontally scrolling podcast sections grouped by category ID
- Podcast detail screen with artwork, description, share action, and episode list
- Episode rows showing title, description, publish date, and duration
- Compact mini-player pinned to the bottom of the screen
- Expanded player sheet with:
  - Play/pause
  - Seek slider
  - Remaining time
  - Skip backward / forward
- Deeplink support for podcast detail routes via the `podcastplayer://` URL scheme
- Background audio enabled through `UIBackgroundModes`

## Architecture

The project follows an `MVVM`-style structure with clear feature separation:

- `Core`
  - Reusable UI components
  - Dependency injection container
  - Shared error handling
  - DTO to UI model mapping
  - Navigation router
- `Features/PodcastList`
  - Podcast discovery UI and state
- `Features/PodcastDetail`
  - Podcast detail, sharing, and episode loading
- `Features/NowPlaying`
  - Shared playback state and player UI

Key implementation details:

- `PodcastListViewModel` fetches the toplist endpoint and groups podcasts by category
- `PodcastDetailViewModel` supports both standard navigation and deeplink-based loading by podcast ID
- `NowPlayingViewModel` owns shared playback state and listens to async playback streams from the audio service
- `Container` uses `Factory` for dependency injection of networking and audio services

## Dependencies

This project uses a small set of libraries/packages:

- `Factory`
  - Used for lightweight dependency injection and easier test mocking
- `Kingfisher`
  - Used for remote image downloading and caching
- `PodcastPlayerNetworkingKit`
  - Provides the networking abstractions and request execution
- `PodcastPlayerAudioKit`
  - Provides audio playback and playback state/time streams
- `PodcastPlayerDeeplinkKit`
  - Provides deeplink parsing and deeplink URL generation

## Error Handling and Edge Cases

The app includes explicit handling for:

- Empty podcast responses
- Empty episode responses
- Podcast lookup failures during deeplink navigation
- Invalid or missing episode audio URLs
- Generic network or unexpected failures

UI feedback is provided through:

- `ProgressView` during loading
- `ErrorView` for recoverable and non-recoverable states
- Retry actions on list/detail fetch failures where appropriate
- Playback loading feedback in the play/pause control

## Testing

The test target uses Apple’s `Testing` framework and currently covers:

- `PodcastListViewModel`
- `PodcastDetailViewModel`
- `NowPlayingViewModel`
- `NavigationRouter`
- DTO to UI model mapping
- `Utils`

Tests focus on state transitions, retry behavior, model mapping, navigation behavior, and playback edge cases.

## Requirements

- Xcode with SwiftUI support
- Internet access for podcast and image loading

No additional environment setup is required for the default configuration.

## Running the Project

1. Open the Xcode project/workspace for `PodcastPlayer`.
2. Select the `PodcastPlayer` app scheme.
3. Build and run on an iOS simulator or device.

The API base URL is already configured in [`PodcastPlayer/PodcastPlayer/Info.plist`](/Users/gregross/projects/PodcastPlayer/PodcastPlayer/PodcastPlayer/Info.plist:1):

- `API_BASE_URL = https://the-podcasts.fly.dev/v1/`

## Running Tests

In Xcode:

1. Select the `PodcastPlayerTests` target or the `PodcastPlayer` scheme.
2. Run the test suite with `Product > Test`.

## Notes

- Podcast categories are currently displayed by category ID because the API response does not provide category display names in this app layer.
- The featured podcast is selected from the fetched dataset because the API used here does not expose a dedicated featured endpoint.
- The project includes localized string catalogs for podcast list, podcast detail, and error messaging.
