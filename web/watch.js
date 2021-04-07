var video = videojs('video', {
    controlBar: {
        fullscreenToggle: true
    }
});

video.ready(function() {
    console.log("video.js ready")
});

const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);

console.log("BKTV Player v1.3.1");

video.src('https://tv.bk1031.dev/' + urlParams.get('id') + '.mp4');

var done = false;

function handleDone(user) {
    done = true;
    console.log("Handling setup for video completion");
    firebase.database().ref('/users/' + user.uid + '/history/' + urlParams.get('id') + '/watched').set(true);
    firebase.database().ref('/users/' + user.uid + '/continue/' + urlParams.get('id')).remove();
    if (urlParams.get('id').includes('-')) {
        // this is an show, try and find next episode
        var currSeason = parseInt(urlParams.get('id').split('-')[1].split('S')[1].split('E')[0]);
        var currEpisode = parseInt(urlParams.get('id').split('-')[1].split('E')[1]);
        console.log("Current Season: " + currSeason);
        console.log("Current Episode: " + currEpisode);
        firebase.database().ref('/videos/' + urlParams.get('id').split('-')[0] + '/episodes/S' + currSeason + 'E' + (currEpisode + 1)).once('value').then(function(snapshot) {
            if (snapshot.val() != null) {
                // try next episode
                console.log("Setting S" + currSeason + "E" + (currEpisode + 1) + " as next");
                firebase.database().ref('/users/' + user.uid + '/continue/' + urlParams.get('id').split('-')[0] + '-S' + currSeason + 'E' + (currEpisode + 1)).set({
                    "progress": "0/1",
                    "date": new Date().toDateString()
                });
            }
            else {
                // try next season
                firebase.database().ref('/videos/' + urlParams.get('id').split('-')[0] + '/episodes/S' + (currSeason + 1) + 'E1').once('value').then(function(snapshot) {
                    if (snapshot.val() != null) {
                        // try next episode
                        console.log("Setting S" + (currSeason + 1) + "E1 as next");
                        firebase.database().ref('/users/' + user.uid + '/continue/' + urlParams.get('id').split('-')[0] + '-S' + (currSeason + 1) + 'E1').set({
                            "progress": "0/1",
                            "date": new Date().toDateString()
                        });
                    }
                    else {
                        // nothing else to try
                        console.log("end of show!");
                    }
                });
            }
        });
    }
}

firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
        // User is signed in.
        console.log("User signed!");
        console.log(user.uid);
        console.log(user.email);

        firebase.database().ref('/users/' + user.uid + '/history/' + urlParams.get('id')).once('value').then(function(snapshot) {
            if (snapshot.val()["watched"] != null && snapshot.val()["watched"]) {
                // Erase watched status and start from 0
                console.log("Already watched! Starting over");
                firebase.database().ref('/users/' + user.uid + '/history/' + urlParams.get('id')).update({
                   watched: false,
                });
            }
            else if (snapshot.val()["progress"] != null) {
                // Navigate to last timestamp
                console.log("Starting from last position");
                video.currentTime(parseInt(snapshot.val()["progress"].split('/')[0]));
                video.play();
            }
            else {
                console.log("First time viewing!");
                video.play();
            }
        });
        video.on('timeupdate', function () {
            firebase.database().ref('/users/' + user.uid + '/history/' + urlParams.get('id')).update({
                "progress": Math.round(video.currentTime()) + '/' + Math.round(video.duration()),
                "date": new Date().toDateString()
            });
            // update continue watching page
            if (!done) {
                firebase.database().ref('/users/' + user.uid + '/continue/' + urlParams.get('id')).set({
                    "progress": Math.round(video.currentTime()) + '/' + Math.round(video.duration()),
                    "date": new Date().toDateString()
                });
            }
            if (video.currentTime() / video.duration() > 0.9 && !done) {
                handleDone(user);
            }
            else if (video.currentTime() / video.duration() < 0.9) done = false;
        })
    } else {
        // User is signed out.
        console.log("User not signed!");
    }
});