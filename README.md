# Hole Filling

This is a take home test.

> The goal of this task is to build a small image processing library that fills holes in images, along with a small command line utility that uses that library, and answer a few questions.

See detailed assignment in [Hole Filling 3 - Interview Exercise.pdf](./docs/Hole%20Filling%203%20-%20Interview%20Exercise.pdf).

## Goals

1. Solve the assignment.
2. Demonstrate the ultra-modular design of decoupled composable components.

![Lenna](./docs/Lenna.png)

## CLI

To see in action change your current console directory to `fill-hole` Swift Package folder and run the following command

```console
$ swift run fill-hole -h
```

to see `fill-hole` command line _description and arguments_:

```console
OVERVIEW: Image Hole Filler.

`fill-hole` is a command line utility that fills the hole in the image.
Provide URLs for the source image and hole (mask), parameters of the weight function `z` and `e`, and (optional) output
image file name.

USAGE: fill-hole <source> <mask> <z> <e> <connectivity> [<output-file>]

ARGUMENTS:
  <source>                Source image URL.
  <mask>                  Hole (mask) image URL.
  <z>                     `z` parameter of the weight function.
  <e>                     `e` parameter of the weight function: small float value used to avoid division by zero.
  <connectivity>          Pixel connectivity type: 4 or 8.
  <output-file>           (Optional) name of output file without extension. The command only writes to the current
                          directory. (default: output)

OPTIONS:
  -h, --help              Show help information.
```

Output file name could be omitted, its extension, if provided, is ignored (for simplicity of v.001).

Run the following command:

```console
$ swift run fill-hole <image url> <hole url> 2 0.001 4
```

Drag-n-drop image file instead of `<image url>`, and mask (hole) file for `<hole url>`.

If you miss any argument you'll see an error, for example:

```console
Error: Missing expected argument '<connectivity>'
Help:  <connectivity>  Pixel connectivity type: 4 or 8.
Usage: fill-hole <source> <mask> <z> <e> <connectivity> [<output-file>]
  See 'fill-hole --help' for more information.
```

URLs of the source, mask, and output would be printed when the command finishes successfully. Run `ls` to list folder contents, including the output image:

```console
$ ls
Package.resolved	README.md		Tests			output.png
Package.swift		Sources			docs
```

Run `open output.png` to open it.

## Package Structure

The solution is implemented using _Swift Package_.

To simplify reasoning, have clear responsibilities, and construct decoupled components, we divided the codebase into the following targets inside one Swift Package:

* `fill-hole` (executable target)
* `FillHoleCommand`
* `FillHoleLib`
* `GrayscaleIOLib`

![Package](./docs/package.png)

`FillHoleCommand`, `FillHoleLib`, and `GrayscaleIOLib` are accompanied by tests in their respective test targets.

## Modules

Here is the top-level view of modules and dependencies:

![Modules](./docs/modules.png)

Here is more detailed view with components:

![Components](./docs/components.png)

* Command line utility `fill-hole` is a simple thin executable wrapper for the `FillHoleCommand`.  

* `FillHoleCommand`

    `FillHoleCommand` accepts an `input image` file, `hole` (mask) file, weight function parameters `𝑧` and `ε`, and `connectivity` type, fills the hole and writes the result to an output image file.

    It's implemented using [Swift Argument Parser](https://github.com/apple/swift-argument-parser) by Apple.

    `FillHoleCommand` as a `ParsableCommand` uses its default implementation of the static func `main()`. To preserve the functionality and compatibility, there is no way of using constructor injection with `FillHoleCommand`. As a compromise, we use implicit dependencies (`Valuator` and `Runner`) considering `FillHoleCommand` a __composition layer__, that wraps `Valuator` and `Runner` logic.

    `Valuator` and `Runner` use constructor injection with polymorphic interfaces, so we can easily swap their dependencies.

    The `FillHoleCommand` doesn’t support an arbitrary weight function, only the default one with configurable 𝑧 and ε.

* `FillHoleLib`

    `FillHoleLib` is a module with algorithm for hole filling. Its two main components are `HoleFiller` and `Balance`.

    `HoleFiller` is initialized with `PixelConnectivity` and `Balance` and has a function to `fill` the hole in the image.

    `Balance` holds `WeightFunc`, either arbitrary or `default` weighting function   
    ```
        1 / (||u - v||^z + ε),
    ```
    where `ε (epsilon)` is a small float value used to avoid division by zero, and `||u - v||` denotes the euclidean distance between `u` and `v`.

* `GrayscaleIOLib`

    This is not a generic file IO operations suite, but a very concrete case of loading grayscale images from files and saving such images using `ImageIO`, the performant API from Apple ([`CGImageSource`](https://developer.apple.com/documentation/imageio/cgimagesource), [`CGImageDestination`](https://developer.apple.com/documentation/imageio/cgimagedestination/)).

## Questions

> 1. If there are 𝑚 boundary pixels and 𝑛 pixels inside the hole, what’s the complexity of the algorithm that fills the hole, assuming that the hole and boundary were already found? Try to also express the complexity only in terms of 𝑛.

- `O(n * m)`
- `O(n * √n)` - idea: `n` is like the area of the hole, and `m` is the perimeter, so O(m) ≃ O(√n).

> (a) Could you imagine the case where it would be `O(n * n)`?

- Yes, consider long thin rectangle - its perimeter would be `~O(n)` and overall complexity would be `O(n²)`.

> 2. Describe an algorithm that approximates the result in 𝑂(𝑛) to a high degree of accuracy. Bonus: implement the suggested algorithm in your library in addition to the algorithm described above.

We could change each hole pixel color to the average color of the boundary.
In this case, the complexity would be `O(n + m)`, where `m < n`, which is equivalent to `O(n)`.

A more granular approach would be the following: divide the boundary into k sets of pixels, calculate average color and "average" coordinates for each set thus creating a set of pixels `newBoundary`, and run the basic algorithm against the original hole and newBoundary.   
Complexity:   
- Creating newBoundary of `k` pixels from the original boundary of `m` pixels: `m`
- Filling the hole: `k * n`
- Total `O(m) + O(k * n) ≲ O(n)`

> 3. Bonus (hard!): Describe and implement an algorithm that finds the exact solution in 𝑂(𝑛𝑙𝑜𝑔𝑛). In this section, feel free to use any algorithmic functionality provided by external libraries as needed.

In this case I would think about gradually shrinking boundary and hole:
```
// pixelConnectivity: PixelConnectivity is given
let neighborhood: (Pixel) -> [Pixel] = { pixel in
    pixelConnectivity.neighbours(of: pixel)
}

// copy already found boundary: Boundary = Set<Pixel>
var boundary = boundary
// copy existing hole: Hole = Set<Pixel>
var hole = hole

while !hole.isEmpty {
    let neighbours = boundary.map(neighborhood).reduce([], +))
    // boundary shrinking inwards
    let newBoundary = Set(neighbours).intersection(hole)
    newBoundary.forEach { pixel in
        // paint pixel using neighbours in boundary
        // ...
    }

    hole = hole.subtract(newBoundary)
    boundary = newBoundary
}
```

## A note for the (near) future

The upcoming `macOS13` is able to work with `async` commands, i.e. `FillHoleCommand.main()` would be able to run asynchronously.
