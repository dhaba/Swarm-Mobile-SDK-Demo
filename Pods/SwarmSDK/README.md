Swarm-iOS-SDK
==================

##Intro to the Swarm iOS SDK                                                                                                                                                                        
Swarm’s iOS SDK enables your mobile application to access real-time contextual information about your user’s current environment, personal attributes, and previous shopping behavior. Every time one of your users is within range of a Swarm beacon (maximum range is approximately 40 ft.), this SDK can be used to trigger actions, notifications, etc… based on proximity to Swarm devices. You can use the Swarm SDK to enable real-time interactions with your users when they’re in certain physical spaces or passively to learn more about their shopping behaviors.

##A Short Intro to Beacons

Swarm has two products that act as iBeacons (read: bluetooth low energy beacons). Swarm Ping is solely an iBeacon and Swarm Portal, an infrared door counter, also functions as an iBeacon. More info about Swarm’s product line can be found on [Swarm's website](http://swarm-mobile.com/).

For the purposes of this SDK, we can talk about a beacon being made up of 3 main components: the broadcast UUID, the major and the minor.
* The broadcast UUID is the beacon’s principal identifier. All of Swarm’s beacons advertise the same UUID so your app only has to monitor for one region.
* The major and minor are each integer values that help to identify which beacon the handset is in range of. Each one of our devices has its own major and then each individual device has a unique minor value.

Note: Swarm technically has two UUIDs, a demo version and a production version. 
* Production UUID: `45FB2AE1-A73B-4ECC-852D-DB5BDFCB4F1C`
* Demo UUID: `E2C56DB5-DFFB-48D2-B060-D0F5A71096E0` 

##SDK Setup
You should have already received an email giving you access to your Swarm Developer Dashboard. If so, logging in to the dashboard will give you access to your Partner Id and API key for using this SDK. The API key is your individualized key and you should take care to keep it secure and secret. If you do not have a PartnerID or an API Key please reach out to [support@swarm-mobile.com](mailto:support@swarm-mobile.com).

Swarm has developed a CocoaPod to make integrating the Swarm SDK as simple as possible. If you’re not familiar with CocoaPods you can learn about them at the links below:
[http://guides.cocoapods.org/using/getting-started.html](http://guides.cocoapods.org/using/getting-started.html)
[http://www.raywenderlich.com/64546/introduction-to-cocoapods-2](http://www.raywenderlich.com/64546/introduction-to-cocoapods-2).
In order to get started, you need to create a podfile for the swarm SDK.  Your podfile should look like this:

```
target "SDKDemo" do

pod 'SwarmSDK', :git => 'https://github.com/Swarm-Mobile/Swarm-iOS-SDK.git'

end
```

Run `pod install` in Terminal and then you're ready to use the Swarm SDK in your project.

After this you can import the SwarmSDK.h header file. To get an instance, call `[[SwarmSDK alloc]init]`.

It is expected that there is only one instance of the class stored inside a singleton object. Each time you navigate to a new view controller, you can set up the delegates provided by the SDK, so the actual controller will always get notification from the SDK. As the application uses core location so the appropriate permissions have to be enabled for the project.

Before using the SDK, you have to setup the API key, which is unique for every developer using the SDK. This will be assigned to you when you get the package, and can be set by calling the `setSwarmApiKey method`.

![How to set up your API key](http://swarm-mobile.github.io/Swarm-iOs-SDK/images/api_instance.png)

In addition to the API key, each request will also need to provide a remoteId and partnerId. The partnerId represents you, as a SwarmSDK implementor, and is identical to your username and is also in the Swarm Developer Dashboard upon log in. This can be set with the `initPartnerId` function. The `remoteId` is the email address of your currently logged in user. You can set this with the `initRemoteId` method.

These and several other pieces of data are used to sign all requests sent to our servers and maintain maximum security of the communication for all SDK calls. The API key is never transmitted directly.


##How it works
By integrating the Swarm iOS SDK with your application, you will be able to understand and engage with your users like never before. Upon first connection with the Swarm Beacon, our database will assign a unique identifier. As your application user moves throughout the physical world, Swarm Beacons and in-store POS integrations will capture their activities. The Swarm Collective Intelligence Database will then establish linkages between these activities to paint a detailed picture of their offline behavior, presented to you in the form of a comprehensive shopper profile.

The Swarm iOS SDK toolkit consists of a set of services to facilitate data exchange

* __WhereAmI__ Match user with a specific beacon, to identify where they are in-store.
* __WhatIsHere__: Identify campaigns associated with that specific location, and match items/brands to that place.
* __DoSwarmLogin__: Create a Swarm ID for user, for a faster way to find them. Exchange app data with Swarm data.


In order to best leverage Swarm’s Beacon Ecosystem it is important to carefully consider exactly what the SDK is able to do and it’s limitations when trying to implement your use case.

The iBeacon standard, which Swarm Beacons adhere to, is an extension of iOS’s [Location Services](http://support.apple.com/kb/HT6048). One of the services that it offers is Region Monitoring. In geographical terms a Region would be a circular region centered around a lat/long coordinate. In iBeacon terms this would be a network of iBeacons defined by a shared UUID. 

Region Monitoring is able to wake the app up from running in the background or if closed when the app enters or exits the region.

Once the App is awoken it can run for ~10 seconds if closed completely and ~2 minutes if it is running in the background. The only triggers that will wake the App from closed or running the background is if you enter or exit the region, e.g. when the App first detects something broadcasting the monitored UUID and when it can no longer detect the UUID.

While the App is running actively in the foreground it can range which determines signal strength between Beacons it has detected and itself. iBeacon uses signal strength to estimate distance. It buckets the estimated distance into 1 of 3 proximity ranges:

1. __Immediate:__ 0 - 6 inches
1. __Near:__ 6 inches - 4 feet
1. __Far:__ 4 feet - 40 feet

__Note:__ Given that distance is estimated based on signal strength there may be some variance in when proximity ranges transition for you. This variance can be due to interference from other physical objects or devices broadcasting in the same frequency range (Bluetooth/WiFi devices).

Consider the proximity ranges and the state of the App (Closed/Background/Foreground) relevant to your use case. Fundamentally the SDK extends the set of signals that your App can use to trigger App behavior like sending a notification or checking a user in.

While closed or in background the Swarm SDK empowers your app to wake and to trigger behavior if/when it enters/exits the Swarm Beacon Region.

While running in the foreground the SDK empowers your app to trigger behavior based on the app’s proximity to the Beacon and knowledge of the user.

##Data Exchange
Swarm aggregates data from the consumer, the beacon, and the application. Each time your user is in proximity of a Swarm Beacon, we securely capture the following elements from each source:

![](http://swarm-mobile.github.io/Swarm-iOs-SDK/images/how_it_works_01.png)

![](http://swarm-mobile.github.io/Swarm-iOs-SDK/images/data_exchange_1.png)

The Swarm iOS SDK offers a flexible framework for you to achieve varying levels of micro-marketing. You can determine the data fields that your app will receive. The more fields you specify, the higher level of data specificity we are able to deliver. The table below outlines fields and data points that your app can receive, or you can create new fields:

![](http://swarm-mobile.github.io/Swarm-iOs-SDK/images/data_exchange_2.png)

By integrating with our SDK, you will attain direct access to the SCI Database and have the freedom to aggregate and process the data using the same protocols you currently employ within the rest of your application or the option to leverage our dashboard to visualize the consumer data.

__Note:__ As per Apple’s App Store policies, we do not recommend collecting the IDFA if your app does not display an ad as it is likely your app will be rejected.

##SDK Services Documentation
More detailed documentation on the SDK's services and how to use them and the data they return is available  [here](http://swarm-mobile.github.io/Swarm-iOs-SDK/index.html).

##Contact Us
If you find any issues with the SDK or have interesting use cases that you would like supported please reach out to your Swarm point of contact or email us at support@swarm-mobile.com
