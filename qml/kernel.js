var kernel = new Array()

function serialize() {
    var kernelStr = ""
    for (var i = 0; i < kernelSize; ++i) {
        for (var j = 0; j < kernelSize; ++j)
            kernelStr += Kernel.kernel[i * kernelSize + j] + " "
    }
    document.customFilter(kernelSize, kernelStr)
}
