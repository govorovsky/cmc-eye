var imageFilter = "Images (*.jpg *.jpeg *.png *.bmp)"

function loadFromFile(context) {
    if (document.modified) {
        // todo
    }

    var file = util.openFileDialog("Choose image to edit", ".", imageFilter)
    if (file === "")
        return;
    document.source = file
}

function channelIconColor(channel) {
    if (channel == "value")
        return "gray";
    return channel;
}

function channelMaxColor(channel) {
    if (channel == "value")
        return "white";
    return channel;
}

function autoLevels(histogram) {
    ["red", "green", "blue"].forEach(function(channel) {
        var low = histogram.getLow(channel);
        var high = histogram.getHigh(channel)
        document.adjustContrast(low, high, channel);
    });
}
