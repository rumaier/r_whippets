// wheres me const? wheres me let? wheres me var? y r u gey?

function ShowControls(contents) {
    let progress = document.getElementsById("progress-bar");
    let controls = document.getElementsById("controls-ui");
    progress.value = contents;
    controls.style.display = "flex";
}

function UpdateProgressBar(contents) {
    let progress = document.getElementsById("progress-bar");
    let oldValue = progress.value;
    for (let i = oldValue; i > contents; i--) {
        setTimeout(() => { progress.value = i; }, 10);
    }
}

window.addEventListener('message', (event) => {
    if (event.data.type === 'showControls') {
        ShowControls(event.data.contents);
    } else if (event.data.type === 'hideControls') {
        document.getElementsById("controls-ui").style.display = "none";
    } else if (event.data.type === 'updateProgressBar') {
        UpdateProgressBar(event.data.contents);
    }
});