// wheres me const? wheres me let? wheres me var? y r u gey?

function ShowControls(contents) {
    let progress = document.getElementById("progress-bar");
    let controls = document.getElementById("controls-ui");
    progress.value = contents;
    controls.style.display = "flex";
}

function UpdateProgressBar(contents) {
    let progress = document.getElementById("progress-bar");
    let oldValue = progress.value;
    let interval = setInterval(() => {
        if (oldValue > contents) {
            progress.value = --oldValue;
        } else {
            clearInterval(interval);
        }
    }, 10);
    if (progress.value === 0) {
        document.getElementById("controls-ui").style.display = "none";
        clearInterval(interval);
    }
}

window.addEventListener('message', (event) => {
    if (event.data.action === 'showControls') {
        ShowControls(event.data.contents);
    } else if (event.data.action === 'hideControls') {
        document.getElementById("controls-ui").style.display = "none";
    } else if (event.data.action === 'updateProgressBar') {
        UpdateProgressBar(event.data.contents);
    }
});