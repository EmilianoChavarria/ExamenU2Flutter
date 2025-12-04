importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyDxfjZDQ4w-Xpdyyv5qYDqI3p4Pz6t6Bj8",
    authDomain: "asd-examen.firebaseapp.com",
    projectId: "asd-examen",
    storageBucket: "asd-examen.firebasestorage.app",
    messagingSenderId: "61034565272",
    appId: "1:61034565272:web:dfcaace87b7f17b4428aed",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});
