# elm-from-ground-up

Welcome to Razoyo's Elm learning lab. The approach of this lab is to start with the most basic possible Elm hello world and build to use more and more features of the language progressively.

The idea is that you can start playing with a limited set of features and gradually add more data types and functionality as you progress.

## Lab 13 - Elm UI

In some ways this is a major refactoring of the codebase. Now that the application is growing (though small by any standard) I'm going to create a new module to manage styling. If I were writing an application, I would probably keep this in the main file because it's just as easy to read... maybe easier than in Lab 12. However, I wanted to show how to use modules.

Additionally, we're going to replace our view HTML, html events and styles with [Elm-ui by mdgriffith](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/). 

To get this to work on your machine, you'll need to have Elm-ui installed. Just got to the project root and run `elm install mdgriffith/elm-ui` and you should be good to go. If you don't have it installed in your Elm library globally, you'll probably get an error.

## How to use the lab

The lab is organized in numbered, step-wise versions. We recommend cloning the repository onto your development environment and check out each numbered branch successively.

To run the demo simply run `elm reactor` from the project root and navigate to src/Main.elm.

## Contributing

Feel free to submit pull requests. We will attempt to review and either comment on them or merge them in a relatively timely manner. The repository is managed by volunteers with day jobs, so, please be patient.

To report bugs or request feature enhancements, just open up an issue.

Happy Elming!
