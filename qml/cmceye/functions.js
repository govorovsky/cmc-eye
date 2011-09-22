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
