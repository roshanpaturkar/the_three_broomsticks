importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'AIzaSyDGmGEhf2j4rsFmKhobMh1I3PooPFilT-k',
    appId: '1:951327074044:web:6f17d0e4bde8dd4ef6d979',
    messagingSenderId: '951327074044',
    projectId: 'd3broomsticks',
    authDomain: 'd3broomsticks.firebaseapp.com',
    databaseURL: 'https://d3broomsticks-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'd3broomsticks.appspot.com',
    measurementId: 'G-NKRM8E5Z83',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});