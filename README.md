#Bacon Finder
This is a command line application that returns the shortest path from any actor in our data set to Kevin Bacon.

###Prerequisites
You will need a recent version of Ruby. To install on a Mac, type the following into your terminal:

```
$ curl -L https://get.rvm.io | bash -s stable
$ CC=/usr/bin/gcc-4.2 rvm install 2.1.1
$ rvm use 2.1.1
```

###How to Use
Clone this repo. From the root directory, type:

	$ ruby bacon_finder.rb
	
This will start the command line interface. From there, just type an actor name. Here are a few to try:

```
Harrison Ford
Minnie Driver
Brad Pitt
Kevin Bacon
```

Have fun!

###Discussion

#####Breadth First Search
I used a breadth first search algorithm because the average bacon number is 3, which means that most searches will be relatively shallow. The problem lends itself naturally to a node graph, so breadth or depth first searches were natural choices, but depth first search would have been less efficient given the low average distance.

#####Implementation
I took an object-oriented approach and built a Node class and a BaconFinder class. The BaconFinder class in particular is not strictly necessary, and a more procedural approach would have worked fine, but I felt it added semantics, especially when building the CLI.

I chose to break the search out into five major functions: the #load_actors method which parses the json objects in preparation, the #find_bacon method which executes the BFS itself, the #short_path method which trims the traveled_path down to an actual shortest route, the #pretty_path method which formats the path for display, and the #CLI which contains the logic for interacting with the user.

#######load_actors
This method uses the JSON parser from the Ruby standard library. I collect all the file names from the films directory (excluding files beginning with a . to avoid any hidden files like .DS_Store or the ..). I then iterated through each film file, assigning the film itself to a node and then associating it with actor nodes representing its cast.

#######find_bacon
Once I had all the film and actor nodes in memory, I could implement the breadth first search. I used a visited_nodes variable to prevent loops by only visiting each node once. I chose a hash for this because, although it might be slightly less intuitive than an array, checking an array to see if it includes each node would have reduced the efficiency of the algorithm.

#######short_path
Once the BFS search is complete, I find a true shortest path by stepping backwards through the traveled path, removing any nodes which are not connected. This removes all the nodes which were visited but which did not lead to Kevin Bacon.

#######pretty_path
The pretty_path method simply reformats the short_path into a string that clearly shows how each actor and film in the chain is connected.

#######cli
The CLI loads the actors into memory once, then starts a loop. The loop prompts the user for an actor name, then returns the path for the actor chosen. It handles unrecognized actors and breaks the loop when the user types 'quit'.