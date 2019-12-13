# elm-from-ground-up

Welcome to Razoyo's Elm learning lab. The approach of this lab is to start with the most basic possible Elm hello world and build to use more and more features of the language progressively.

The idea is that you can start playing with a limited set of features and gradually add more data types and functionality as you progress.

## Lab 15 - Getting Data from the Outside World

While managing a list in our browser is fun and all, it's time to take things to the next level. Rather than manually entering in our data, we're going to pull it from Github.

Starting with razoyo as the Github id, we'll request the data from the API. It's going to come back as JSON data which we will need to decode. We're going to expand on the JSON decoder which we used (to decode an Enter key event) in our last repo and use it to read the incoming data. More info on the API we are using is available at [github|https://developer.github.com/v3/].

Github returns a lot of data, but, we're only interested in a few fields: id, name and description. We'll update our "Item" type to include those fields and we'll get rid of length and get rid of that sort.

To do all this, you'll notice a few changes:
* We will have to change from Browser.sandbox to Browser.
* With that change we now have to change our update to update not only the model, but, to subscribe to http events - this will allow us pull in the data from GitHub.
* The incoming data is in JSON format so you'll see us parsing and decoding here and there.

If you have worked through the [Elm intro|https://guide.elm-lang.org/] the above may make sense to you. Even if you have but feel uncomfortable with some of the concepts, I encourage you to review the relevant sections of the guide --- I did before writing the code here!


## How to use the lab

The lab is organized in numbered, step-wise versions. We recommend cloning the repository onto your development environment and check out each numbered branch successively.

To run the demo simply run `elm reactor` from the project root and navigate to src/Main.elm.

## Contributing

Feel free to submit pull requests. We will attempt to review and either comment on them or merge them in a relatively timely manner. The repository is managed by volunteers with day jobs, so, please be patient.

To report bugs or request feature enhancements, just open up an issue.

Happy Elming!
