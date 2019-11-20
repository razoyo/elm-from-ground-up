# elm-from-ground-up

Welcome to Razoyo's Elm learning lab. The approach of this lab is to start with the most basic possible Elm hello world and build to use more and more features of the language progressively.

The idea is that you can start playing with a limited set of features and gradually add more data types and functionality as you progress.

## Lab 14 - Handling Enter

Because elm-ui doesn't have a form element, we need to handle the event of an enter key being pressed. We do this in two basic steps:
1 - Add a function that creates and enter key event 
2 - Add handle the enter event function in our text input elements

In addition, the enter key event function uses the decoder, so, we import the decoder and the HTML events to accommodate that.

To get this to work on your machine, you'll need to have Elm JSON installed. Just got to the project root and run `elm install elm/json` and you should be good to go. If you don't have it installed in your Elm library globally, you'll probably get an error.

## How to use the lab

The lab is organized in numbered, step-wise versions. We recommend cloning the repository onto your development environment and check out each numbered branch successively.

To run the demo simply run `elm reactor` from the project root and navigate to src/Main.elm.

## Contributing

Feel free to submit pull requests. We will attempt to review and either comment on them or merge them in a relatively timely manner. The repository is managed by volunteers with day jobs, so, please be patient.

To report bugs or request feature enhancements, just open up an issue.

Happy Elming!
