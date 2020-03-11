# nimixil
Xil in Nim. A learning experiment.

> More info about [Xil](https://github.com/basp/xil).

Lessons learned so far:
* Since there are no decent parser combinators available for Nim this means that the scanner and parsers had to be written by hand. This turned out much better than I could ever hoped for.
* Turns out that using object variants instead of full fledged objects does not work out nicely. You'll end up with lots of nested *kind* checks and even after writing one simple binary operator in this style I gave up.
* It is much much easier to use dynamic dispatch on actual object types. You probably want to add `--multimethods:on` in your `nim.cfg` for this otherwise you'll run into (possibly cryptic) errors. And no, dynamic dispatch is not optimal for performance but you can always optimize the heck out of those low level operators later. Until everything is rock solid we are not going to optimize much and keep the code simple.
* Templates are really cool but they sometimes give this annoying `generic instantation` error that can be a PITA to solve. Usually this only surfaces when you actually try to use to template. The error message can help but when you try to glance it in VSCode it doesn't always behave nicely. Just give it a quick compile and Nim will probably spit out a list of more readable errors in the console.
* I did not even think of using a fallback *base* implementation for methods in the Xil implementation (or I didn't trust .NET to resolve the right method). It might save me a *lot* of switch expressions and statements if that actually works as expected (i.e. like in Nim).
* The compiler and the binaries Nim creates are really snappy. I mean, *really* snappy compared to what I'm used to. Programs wait for me instead of the other way around (which is always refreshing). 