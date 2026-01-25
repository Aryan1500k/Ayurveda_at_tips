importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js");

// Use the config values found in your lib/firebase_options.dart
firebase.initializeApp({
  apiKey: 'AIzaSyBAH2utZxuBNTs1Uk4f_5CRPLCx3nPZb_o',
  authDomain: 'ayurvedaapp-91230.firebaseapp.com',
  projectId: 'ayurvedaapp-91230',
  storageBucket: 'ayurvedaapp-91230.firebasestorage.app',
  messagingSenderId: '819161511250',
  appId: '1:819161511250:web:a09ec30ffdd007fb52f68b',
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log("Background message received:", payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/icons/Icon-192.png", // Ensure this path exists in your web/icons folder
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});