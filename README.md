# Architecture

I architected the app using the **MVVM** pattern. I am comfortable with this architecture because it separates logic from the views, keeping them passive, which makes the app more manageable and simplifies writing tests. This pattern is intuitive, as the ViewModels react to the data they receive from the Models and Services. It is also very scalable, which proved beneficial as I expanded the app's logic. I was able to add a single test case to cover the new logic seamlessly. With something like MVC, it would be easier for logic to creep into the view, which can lead to more complex and less maintainable code.

# APIClient

I used Postman to structure the JSON response and create my `CatImage` model and the nested `BreedDetails` model to decode the data. Postman was also helpful when creating my `CatAPIClient` to fetch data. It allowed me to query the API, determine the total breed count, and set my limit of items accordingly.

In my `CatAPIClient`, I used **async-await** as it is the simplest and most readable method for fetching data. It involves much less boilerplate code than the Combine method.

## URL Building

I took care to build the URL in a reusable way, so it can be extended for more search parameters by adding additional paths or query items. If the endpoint were modified, this approach would make it more maintainable.

## Protocol and Testing

I created an `APIClient` protocol and a `MockAPIClient` to allow me to test the methods in the ViewModels. I also used the MockAPIClient in my previews, to accelerate development, and allow me to force states like loading, loaded and error.

# Caching

I created a `CacheManager` with `save` and `get` methods to store data in a temporary cache. I then used the manager in my `ImageLoader` service. The service checks the image URL against those saved in memory and returns it from the cache if successful. Otherwise, it enters a `do-catch` block for an async-await call to fetch the image. If successful, it saves the image in the cache. The async code works well in the `do-catch` block, making it easy to handle errors.

The `ImageLoader` is initialized as an `EnvironmentObject` at the top level of the app's hierarchy. This means the entire app and its views share a single instance of the `ImageLoader` and the `CacheManager`, which helps avoid redundant API calls for images already in the cache.

# UI and App Flow

For the primary `BreedSelectionView`, I used a **List** because it has built-in support for insertion, deletion, and reordering. Most crucially, I wanted to use the `searchable` modifier to filter data. The List provides a consistent "Apple" feel that is immediately usable, but it can also be customized to suit the desired app theme or color palette. This was worth the trade-off of not creating custom cells, which do not easily offer the same functionality. The logic for filtering and data gathering is managed by the ViewModel and is called asynchronously in an `onAppear` within a `Task` block.

## Navigation

Each list item is a `NavigationLink` that pushes to the `BreedDetailView`. At the time of pressing, it injects the `breedDetails` data array to populate the text and injects the `BreedDetailViewModel`, which is used for fetching images, again adhering to MVVM principles.

By placing the list view in a `NavigationStack`, it manages the view hierarchy smoothly and intuitively, also tracking state preservation. This means that if we search the list and push to a breed, when we return, it is still in its filtered/previously scrolled-to state.

# BreedDetailView UI

The UI of the `BreedDetailView` is less formally structured as I wanted this screen to feel more bespoke and engaging. I took advantage of the new **ScrollView APIs** like Paging behavior and `scrollTransition`, manipulating the offsets and scale to create a carousel effect.

The `catImageGallery` is built using a subview called `CachedAsyncImage`, which uses the `EnvironmentObject` `ImageLoader` to fetch images. While fetching, a `ProgressView` is shown with a default background color of 'sunset', a color from the palette used throughout, creating a feeling of consistency. Functionally, it shows the user that there are more items, even when they aren’t yet fetched. The images are made uniform in size and given rounded corners. When pressed, it pushes to an expanded image view for a non-cropped view of the image. This is handled seamlessly with `NavigationLink` and is loaded instantly from the cache.  I took advantage of the `Text` initializer `Text(repeating repeatedValue: String, count: Int)`, which uses the `Int` values to repeat given strings. This approach is very reusable, and I felt comfortable with this level of logic taking place inside the view.

# Next Steps

- **APIClient Improvements**:
  - Get requests in the `APIClient` could be made more generic for reuse when more endpoints are needed.
  - I would have put the auth token in an `xcconfig` file, which is a step towards improving the security.

- **Enhanced Filtering**:
  - Include additional search terms e.g. origin
  - In addition to the search bar, I would have added more filtering criteria, perhaps using a picker. 

- **Pagination**:
  - I would have included pagination in the breeds request. Fetching all the data at once can cause delays in the loading UI, which could negatively impact the user experience. This issue could become more pronounced as the data set grows larger.

