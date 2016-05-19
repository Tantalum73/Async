# Async
A lightweight wrapper around Grand Central Dispatch

Async makes it easy for you to chain operations together that should run on different threads.

## Usage
You have two ways of using Async:
You could use ```.async()``` and ```.then()``` like this:
```Swift
Async.async(QOS: .Background, block: {
    print("Performing Task 1")    
}).then(after: 3, QOS: .Main) { 
    print("Performing Task 2")
})
```
Or  by using ```.main()``` like this:
```Swift
Async.main(block: {
    print("Performing Task 1") 
}).background(after: 3, block: {
    print("Performing Task 2") 
})
```

Both ways use the same mechanics internally so you can chose the syntax you like better.

You can find examples in the Playground file. Please feel free to play around with it :)

##Installation
Just download the ```Async.swift``` file and you are ready to go.

I am also working on support for the Swift Package Manager.

##More Words
I wrote a few lines about this project on [my blog](https://anerma.de/blog/open-source-project-async).
Please let me know if you have any comments ☺️

##License
Async is published under MIT License

    Copyright (c) 2016 Andreas Neusuess (@Klaarname)
    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
    Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 