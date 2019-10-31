# 3 Add Another Message
In this lab/branch we've added another message to the queue.

To accommodate this we had to do the following:
* Change the model to a Tuple type
* Add a 'payload' to the CAPITALIZE message to tell which element of the tuple we are going to modify
* Use pattern matching to make reading the view easier

Happy Elming!
