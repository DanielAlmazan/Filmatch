# 🎬 **Movsy iOS App**
**Movsy** is a native SwiftUI application designed to help you and your friends decide what to watch. Powered by TMDB and Firebase, it offers movie/TV discovery and friend-based matching.

## ✍️ **Authors**

📱 This app was coded by [Daniel Enrique Almazán](https://github.com/DanielAlmazan) as the Final Project for DAM-DAW (Desarrollo de Aplicaciones Multiplataforma / Web).

🖥️ The backend logic is handled by a Go API([Ottermatch-Go](https://github.com/josefrvaldes/Ottermatch-Go)). The API was written by [Jose Francisco Valdés Sirvent](https://github.com/josefrvaldes) and [Daniel Enrique Almazán Sellés](https://github.com/DanielAlmazan).

---

## 🚀 **Pre-requirements**

### 📦 **SDK & Tools**

- Xcode 16+
- Swift 6+
- iOS 18+

---

## ⚙️ **Project Configuration**

### 🔐 **Environment Variables – `*.xconfig`**

You'll need to create the missing `*.xconfig` files in the root directory of your project as the following:

```plaintext
ACCESS_TOKEN_AUTH = {{YOUR_ACCESS_TOKEN_AUTH}}
API_KEY = {{YOUR_API_KEY}}
OTTERMATCH_BASE_URL = {{YOUR_OTTERMATCH_BASE_URL}}
TMDB_URL_BASE = {{YOUR_TMDB_URL_BASE}}
TMDB_MEDIA_BASE = {{YOUR_TMDB_MEDIA_BASE}}
```

For local configuration you can use ngrok. First run MovsyGo in your local machine, then run `ngrok http http://localhost:{{PORT}}` on your terminal. You'll get the URL to use in the `Local.xconfig` file.


### 🧾 **./Movsy/Info.plist**

The Info.plist file will require to set the URL scheme for the app. All the other variables will be set automatically.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_KEY</key>
	<string>$(API_KEY)</string>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Viewer</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>{{YOUR_URL_SCHEME}}</string>
			</array>
		</dict>
	</array>
	<key>OTTERMATCH_BASE_URL</key>
	<string>$(OTTERMATCH_BASE_URL)</string>
	<key>TMDB_MEDIA_BASE</key>
	<string>$(TMDB_MEDIA_BASE)</string>
	<key>TMDB_URL_BASE</key>
	<string>$(TMDB_URL_BASE)</string>
	<key>ITSAppUsesNonExemptEncryption</key>
	<false/>
</dict>
</plist>
```


### 🔥 **./Movsy/GoogleService-Info.plist**

**Movsy** uses Google Firebase for authentication, so you must:
- Create a new *Firebase project*
- Enable Authentication for:
  - Email/Password
  - Apple
  - Google
- `GoogleService-Info.plist` file in the `Movsy` directory of your project.

> Authentication logic based on [SwiftfulThinking](https://github.com/SwiftfulThinking)'s [Firebase SwiftUI Bootcamp](https://github.com/SwiftfulThinking/Firebase-SwiftUI-Bootcamp)
