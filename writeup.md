If I were asked to build this as a full-scale web application, I would create a separate SFAPI service and a FoodTruck class, test drive development, set up an App Token securely to avoid throttling and add a loading indicator/spinner to show the user while retrieving the food truck information. If there is business value in the following features, I would add other sorting, filtering and view options (ie. open at, distance from, by neighborhood, map view, view all) and a details page for each food truck.

If performance with the SFAPI were suboptimal, I would look into caching and may consider using a database and updating at intervals rather than relying on a third-party service in realtime.

[Trello Board for Command Line Program](https://trello.com/b/9pmDclkq)
