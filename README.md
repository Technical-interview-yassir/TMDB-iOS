# TMDB-iOS

![CI pass](https://github.com/Technical-interview-yassir/TMDB-iOS/actions/workflows/main.yml/badge.svg)

## Features

- Display trending movies on the home page
- Search by title on the home page
- Pull to refresh the home page
- Infinite scroll to discover new movies
- Display a detail page for a movie including:
  - The calculated profit generated by the movie
  - Download the best quality image available


## TODOs

- Error Handling
- Favorites
- Sorting
- Router/Coordinator for views (if the project get bigger)


## Development

### Install necessary tools

```
make setup
```

After running the make setup, add your refresh token for [TMDB](https://developer.themoviedb.org/docs) in the `Secrets.plist` file with the key value `TMDB_accessToken` and the token as string.

### Open the project

```
open TMDB.xcodeproj
```

### Format the code

```
make format
```

### Verify Linting issues

```
make lint
```

### Tests

The snapshot tests are generated with an iPhone 14 on iOS 17.2. Be sure to select this device as target in Xcode.

```
make test
```