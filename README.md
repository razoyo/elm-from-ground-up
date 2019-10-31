# 2 Add Message

Here we've added a very simple message so that we can update our model. The `CAPITALIZE` message is passed to the update function when you click on the text.

The `update` function translates the `String` in the model to UpperCase using the `String.toUpper` function.

After the `model` is updated, Elm passes it back to the `view` function which changes the HTML.

Try clicking on the text, you might be surprised at how fast the action is.

We've also added HTML elements and you can see how they are formed as functions that take two `Lists` (they look like javascript arrays, but they are definitely not!) as arguements. The first list includes styling and events. The second list is the content of the element. The content can be another element in a tree structure, but, easier to read than HTML in my book.
