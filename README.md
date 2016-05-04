# Exercism-iOS
iOS app using [exercism.io](http://exercism.io) API with GitHub authentication. This is to help me practice my development skills and increase my proficiency in Cocoa/Swift as well as Ruby/Sinatra/Rails

## OAuth Swift
https://github.com/OAuthSwift/OAuthSwift

I am having the user log in with their GitHub credentials.
- I would like to add an endpoint to exercism's API to return an API key when passed the GitHub token.
Currently it is set to the default configuration where you log in with Safari, but I would like to put this into a `WebViewController`.


## MVC-N
https://realm.io/news/slug-marcus-zarra-exploring-mvcn-swift

I am creating this app around the MVC-N design pattern explained by Marcus Zarra's Realm talk with Core Data as the persistence store.

## Setup
If you wish to clone/run the app you will need to add a file with the following code.

```
var Github =
    [
        "consumerKey": "ABC",
        "consumerSecret": "123"
    ]
```
These values can be obtained by registering it in your GitHub settings under OAuth Applications.

## License

I plan to open this up once I have all of the basic functionality in place, but let me know if you would like to help me get it going!
