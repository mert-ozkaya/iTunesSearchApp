# iTunesSearchApp

Challenge Requirements

We would like to develop an application that uses the iTunes Search API to perform searches and display the downloaded images grouped in a list. The software requirements are as follows:

1. The application should open with a collection view that has a search bar.

2. If there is no content, a "no data" notification should be displayed.

3. Instant search should be performed based on the search key entered in the search bar, according to performance criteria.

4. The search criteria should be "software," using the parameter ~url?media=software.

5. All images within the screenshotUrls list of all items in the response should be downloaded.

6. The download process should be concurrent, with a maximum of 3 threads running simultaneously.

7. Once an image's download process is complete, it should be displayed under its appropriate group on the UI.

8. The list of images on the screen should be organized into grouped sections based on image size (0-100kb, 100-250kb, 250-500kb, 500+kb), resulting in four sections.

9. If a user clicks on an image, a preview of the image in a larger size should be presented through another controller.

10. Source control should be used, and the project can be shared on platforms like GitHub.com.

11. At least one view or, if desired, all views should be written programmatically.

12. Autolayout should be employed.

13. BONUS: Choose an architecture that adheres to clean architecture principles.

14. BONUS: Write unit tests.

15. BONUS: Avoid using third-party libraries.

API: https://performance-partners.apple.com/resources/documentation/itunes-store-web-service-search-api
