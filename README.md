# Passkeys demo
Vapor API and iOS project passkey implementation demonstration.

## Vapor API

* Build images:       docker-compose build
* Start app:          docker-compose up app
* Start database:     docker-compose up db
* Run migrations:     docker-compose run migrate
* Stop all:           docker-compose down (add -v to wipe db)

## Important
In order to make the interaction between android/iOS app and the app site association work, the app needs to run on a public IP. I recommend [Ngrok](https://ngrok.com/) tool and creating a simple tunnel with
```
ngrok http 8080
```

Both projects contain Constants file where you need to put the url/domain.
