var firebaseConfig = {
    apiKey: "AIzaSyBdNklN4LK4CiuW6vsxU_8F4maFFidW3fE",
    authDomain: "bk1031-tv.firebaseapp.com",
    databaseURL: "https://bk1031-tv.firebaseio.com",
    projectId: "bk1031-tv",
    storageBucket: "bk1031-tv.appspot.com",
    messagingSenderId: "914624398214",
    appId: "1:914624398214:web:739a780ba75a21e9206207",
    measurementId: "G-2N60VTM8LG"
};
firebase.initializeApp(firebaseConfig);

var video = videojs('video', {
    controlBar: {
        fullscreenToggle: false
    }
});

video.ready(function() {
    video.tech_.off('dblclick');
});

const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);

console.log("BKTV Player v1.1.0");

video.src('https://tv.bk1031.dev/' + urlParams.get('id') + '.mp4');

firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
        // User is signed in.
        console.log("User signed!");
        console.log(user.uid);
        console.log(user.email);

        firebase.database().ref('/users/' + user.uid + '/history/' + urlParams.get('id')).once('value').then(function(snapshot) {
            if (snapshot.val() != null && snapshot.val().watched) {
                // Erase watched status and start from 0
                console.log("Already watched! Starting over");
                firebase.database().ref('/users/' + user.uid + '/history/' + urlParams.get('id')).update({
                   watched: false,
                });
            }
            else if (snapshot.val() != null) {
                console.log("Starting from last position");
                // TODO: Navigate to last timestamp
            }
            else {
                console.log("First time viewing!");
                video.play();
                // video.muted(false);
            }
        });

    } else {
        // User is signed out.
        console.log("User not signed!");
    }
});