This software is a mathematical model for a group making a binary choice. Let i = 1, ..., N index the choosers. 

Each has a probability, or preference, function p_i (t) which varies over time. A sigmoid function, sigma, which may be a disrete step function, is applied to make a binary choice. 

We then sum the values, and divide by the total. To get a smooth function, we can mollify by using logistic sigmoid with a parameter q. 

A standard example would be a poll tracker, as FiveThirtyEight has, which measures whether or not a group of individuals approves of the president's job performance or not. 