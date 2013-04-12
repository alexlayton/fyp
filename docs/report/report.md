#Abstract

Mobile apps have become increasingly popular with the rise of various mobile operating systems and their respective app stores. These app stores allow users access to a multitude of apps from utilities to games, and as the capabilities of these phones increase the allow more complex apps to be built using the sensors built into the device. A popular mobile operating system is Apple's iOS, which was updated in iOS5 to include a Reminders app. This app features the ability to add geo-fenced location reminders which alerts the user when they are in the specified location. These geo-fenced reminders have few uses, whereas a reminder which could preempt when to alert the user based on their current location and their destination has a wide range of uses.

#Introduction

##Motivation

With the increasing popularity of mobile devices their are more opportunities to create mobile apps which can be distributed through various app stores on a number of mobile operating systems. The operating systems boast millions of users, which collectively download billions of apps from the hundreds of thousands available on their devices app store. Consider Apple's iPhone, which runs iOS. Their latest version of iOS - iOS6 has around 300 million users and their App Store offers over 800,000 apps that have been downloaded a total of 4 billion times (cite apple). This shows what a great opportunity these app stores are and allow smaller developers to distribute their app on a scale thats usually only seen by larger developers. Although their is the possibility of mass user adoption, it is also easy to go unnoticed amongst the other hundreds of thousands of apps.

As the adoption of these devices increases they are being used to complete more and more tasks. These tasks can be important such as calendaring in order to allow the user to organise their time or setting alarms and reminders. Traditionally a reminder simply alerts the user at a set time with the given reminder. As the capabilities of mobile devices have increased and the introduction of GPS and GLONASS (maybe a footnote) sensors have allowed reminders to make use of location data, which can be seen in Apple's Reminders app where instead of a reminder being triggered by a time it is triggered by a location, specifically when the users current location is within a certain distance from the desired location. This technique is known as geo-fencing (cite geo-fencing) and is essentially creating a virtual perimeter around a location so once that area is entered a task can be performed, whether it is downloading something in the background or in this case alerting the user with a reminder. The problem with these geo-fenced reminders is that they do not take time into consideration and as a result are limited in scope - a better solution would be one that considers both location and time. 

By taking into account both location and time these reminders could be used to remind the user dependant on how far away they are from their destination and how long until they need to be there. For instance, if a user set a reminder for half an hour in the future, and it takes 15 minutes to reach that destination, providing the user doesn't move they should be alerted in 15 minutes in order for them to reach their destination on time. The scope of this functionality is much greater than the previously mentioned geo-fenced reminders, which could be used in any application that involves the user reaching a destination before a deadline. This project looks at the implementation of these reminders in the form of an iOS app.

TODO: Talk about whats in the project here...

##Aims

There are several aims involved in this project. First and foremost the main aim of this is to implement the preemptive reminder functionality in an iOS app. The other main aim is to release the proposed functionality in an app available on the App Store. Another aim of the project is to create the preemptive reminder functionality as a library which would allow for other apps to easily make use of these reminders. Since using location services on a device can drastically drain the battery an aim is to try and make the app as efficient as possible by only using location when needed and using these services in a low power mode if possible. The created app to demonstrate the reminders functionality should also have a good user interface, as well as good user experience when adding location reminders.

#Research

##Existing apps

It is important to research existing apps when building an app for a mobile device. As previously mentioned, with hundreds of thousands of apps available on the various distribution channels there is the possibility that the proposed functionality has already been implemented. By looking on the different app stores  its possible to see what applications are already available. The  mobile platforms with the biggest user bases are iOS and Android so its logical to target their respective stores - the App Store  (cite app store) and the Google Play Store (cite play store) as the basis for researching existing apps.

On iOS there exists the previously mentioned Reminders app, which features the geo-fenced reminders functionality. Another app available on the app store is Checkmark (cite checkmark). This app builds upon the functionality in Reminders by allowing the user to set the radius of the geo-fence around a location as well as allowing the user to set a timer to alert them a specified amount of time after reaching the geo-fenced area. Geo-Reminders (cite georeminders) is another app that offers geo-fenced reminders.

For Android the existing apps are very similar in functionality to the ones available on iOS. Milwus Location Alarm (cite app) is an example of geo-fenced reminders.

From the research conducted into existing apps, there are currently no apps that make use of the proposed functionality.

##Objective-C

In order to build an iOS app an understanding of the Objective-C programming language is required. The language builds upon the C language by adding object-oriented patterns. It allows for method and classes as found in other objected-oriented languages while making use of core C APIs. As this report will cover the implementation of an app, it may be useful to demonstrate some parts of the Objective-C language. 

(show example 1 code)

All Objective-C classes have an interface, this is where all the public methods are declared for that class. The method 'hello1' is declared with a '+' which shows that it is a class method, while 'hello2' declared with a '-' is an instance method. In this example the interface is declared inline, but it is more common to find a '.h' file for the interface while the implementation is found in a '.m' file. 

The implementation for both of the methods is straight forward, with them both printing 'Hello, World'. You may notice that the function to print the string is prefixed with 'NS' as well as the class we are inheriting from. This is due to the fact that all classes within the Foundation framework were created for the NextStep platform and as a result still carry the naming convention from this platform. Class prefixes are common in Objective-C for instance the framework for user interfaces on iOS is called 'UIKit' and as a result all classes in this framework being with 'UI'. This project will include similar prefixing of class names. 

Like other programming languages the main method is where the code is executed. Method calls in Objective-C are wrapped in square brackets, with the first word inside the bracket being the class and the second being the method call. As you can see, since 'hello1' is a class method the class does not need to be instantiated while the call to 'hello2' requires the class to be allocated memory and initialised.

Delegation is a widely used programming pattern within Objective-C. Since delegation will be used throughout the project it may also be useful to introduce this concept. According to the Apple Developer Documentation (cite docs), a delegate is an object that acts on the behalf of another object in order to respond to an event received by this other object. For example, a class may hold an instance of a text field (UITextField) and the class may wish to be notified when the user presses the enter key on their keyboard, so the application  can behave accordingly. The documentation shows that the text field has a protocol reference - UITextFieldDelegate and that the textfield has a property called delegate that can be any object that subscribes to this delegate protocol. In order for the class that has the text field to be notified it should set the delegate property of the text field as itself and implement the following delegate method;

- (BOOL)textFieldShouldReturn:(UITextField *)textField

This means that now whenever the enter button is pressed while using the text field, the text field instance calls the above method on the instance that is stored in the delegate property. A better example of delegation is;

(delegation goes here…)

From the above example you can see there is a protocol declaration in class 'A'. This is where the delegate methods are declared and must be implemented by the delegate class. It is possible to add an '@optional' keyword to declare some methods that the delegate is not required to implement, but in this case a delegate must implement all the methods. The class with the protocol must store a pointer to the delegate class in order to store the delegate methods. Class 'B' states that it conforms to the protocol of 'ADelegate' by declaring it at the top of the implementation file. The main method shows how the delegate works, by instantiating class 'A' and setting its delegate property to an instance of class 'B' now when the start method is called from class 'A' when an event is received the method of the delegate class is called. The event for which the delegate was called could be anything, from a button tapped on screen to  an app being exited or sent to the background. 

The tools to write and run Objective-C code are freely available and developers can install the Xcode IDE which provides a toolchain to allow Objective-C code to be compile, run (or simulated), tested and profiled. Xcode requires a machine running Mac OS X, but Objective-C code can be compiled on any machine that can run the llvm compiler. In order for developers to release their apps on the App Store, they must be provisioned and submitted to Apple for approval. An Apple developers license is required in order to do this.

##Literature Review

The Apple Developer Center (cite dev centre) provided all the necessary literature to enable the implementation of this project. This website provides all the necessary documentation to use Apple provided frameworks as well as presentations from developer conferences introducing newly implemented functionality in frameworks and new features in the iOS operating system. Apple also provide example implementations in order to demonstrate presented functionality.

Since the proposed reminder functionality requires location it was important to research into the existing location frameworks and APIs available on iOS. The WWDC presentation - 'Staying on Track with Location Services' (cite presentation) provides a good high level insight into the location technologies used within iOS. This presentation identified several factors needed for the implementation of location reminders. One of these factors is background execution, since reminders are essentially useless if the app can only be run in the foreground. In order to be allowed to execute in the background the app needs to register as an app that can run in the background. The presentation demonstrates how to register as a background app by adding the following to the applications information property list file.

(add plist code)

Although it is possible to run standard location services while in the background, there exists methods within the CoreLocation framework to allow for monitoring of significant changes. These significant location changes make use of cell tower triangulation instead of wi-fi, GPS and GLONASS which is used my the standard location changes.

TODO: Add section on delegation to objective c and then talk about location update thingy

Another factor in this project is using maps. Since reminders will use location, using maps will provide a way to give user specified locations context. Apple also provide a MapKit presentation from their WWDC sessions called; 'Getting Around Using MapKit' (Cite presentation). This presentation introduces the new maps released in iOS6 as well as how to implement them into an app. Since MapKit uses the CoreLocation framework itself in order to show the users current location on a map, it is easy  to use the two frameworks together.

Storyboards provide an alternative way to create user interfaces and were originally introduced with iOS5. This method differs to traditionally used methods to design iOS app such as NIBs (NeXT Interface Builder) and creating the interface completely programatically. The WWDC presentation - 'Adopting Storyboards in your app' (cite) provides insight into how to transition from older interface building methods to the newer Storyboards. Pennington states that there are two main concepts involved with Storyboards, one being scenes and the other segues. The scenes are the view controllers that will display the different views in the application, while segues are the connections and transitions between scenes. (show an image with of storyboard)

These storyboards are created graphically, which are then connected to code by specifying a scenes class. For instance a UIViewController could be dragged onto the storyboard, with a class existing called MyViewController that subclasses UIViewController. This subclass can then be set as that scenes class so when the scene is displayed it instantiates that class as opposed to using a standard UIViewController. Segues are also created graphically by dragging an arrow from a user interface element to a destination scene. Segues can be detected programmatically in order to react to the transition, for instance data can be passed to the destination view controller or data could be saved before the view changes. Since a view could have multiple segues to different destinations, a segue can be given an identifier so that it is possible to detect not only the segue but the destination of that segue. The following method is called in a UIViewController subclass when a segue is about to happen;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

This method takes a segue object and a sender. The sender is the object where the transition is initiated, so if the segue is occurring because of a button press, the sender will be the UIButton that was pressed. The class reference for UIStoryboardSegue (cite ref) shows that it contains a properties for the destination view controller and an identifier. The destination view controller is an an instance of the view that will be displayed to the user, this allows properties of the destination view controller to be set before it is shown to the user. The identifier, like previously mentioned contains the string of the identifier given for that segue.

Since the app will use a custom interface it is important to research how to create an interface using the non standard UI elements available. Apple's WWDC talk on '￼Advanced Appearance Customization on iOS' (cite appearance) demonstrates techniques in order to customise the user interface of an app. The presentation shows that all custom interface elements should be images created at the correct size for the device it is being used on. For instance an image created for a device such as the iPhone 3GS could be called 'myImage.png', while the image for a device such as the iPhone 4 should be called 'myImage@2x.png' and should be twice as big as the original image to account for the increased pixel density of the device. Once the images are named correctly they can be instantiated programmatically simply from the following line of code;

UIImage *myImage = [UIImage imageNamed:@"myImage"];

The presentation also goes on to demonstrate using resizable images as opposed to fixed width ones. One use for resizable images is buttons. Since it is common to have multiple buttons, each with there own text, a resizable image would allow the button to change size depending on the length of text. This is not the case for a button using a fixed width image and the resulting button might be using an image that is much bigger than the text the button holds. A resizable image is created in the following way;

(add resizable image code here and maybe image)

In order to customise the user interface as demonstrated above, the techniques described above would need to every instance of the UIKit objects used in throughout a project. As of iOS5, a UIAppearance property has been added to the various classes found within UIKit (cite NSHipster). UIAppearance offers a way to style the different UI elements once and have them consistent throughout the app. UIAppearance is a protocol that classes in UIKit subscribe to. By calling the appearance class method of a UIKit class, an appearance proxy is returned. The appearance proxy is essentially an another instance of the same class that the appearance method is being called on. This proxy can be customised as if it were a normal object of that class type, but when an instance of that class is created it refers to the appearance instance to customise itself. An example may be a better way to demonstrate this functionality;

(UIAppearance code goes here)

By using UIAppearance it means a lot less code is duplicated in order to create similar looking UI elements throughout the app. Although using this technique allows the majority of properties of UIKit classes to be customised it is not available for some properties, so it may be the case that some particular properties must be customised once instantiated (cite appearance gist).

#Project Specification

From researching existing apps and looking at current programming paradigms and techniques for the iOS platform it may be beneficial to look at the original project aims and redefine them based on this research.

The main aim of this project to implement the proposed reminders functionality. Since this will be an iOS app, this functionality will be implemented in Objective-C, making use of the researched frameworks and techniques. The location component of this app will make use of the CoreLocation framework, using standard location changes in the foreground in order to give the user accurate location data while using the app. Once the app is sent to the background it will transition to significant location change services in order to use as little power as possible. It should also be the case that location is only used when needed and not for the duration the app runs for whether this is in the background or foreground. In order to provide an intuitive interface the app will also use the functionality found in the MapKit framework in order to give the locations received from the location services and given as destinations context to the user. The app will also take advantage of Storyboards to create the user interface as not only will it allow for rapid development of the app, but it allows a clear distinction to be made between user interface and functionality when building the app. The design of the app must be unique while also being consistent to the design language used on the platform, this can be validated from user testing by receiving feedback about the design. The interface should also make use of the previously mentioned UIAppearance protocol in order to create custom yet consistent UI elements throughout.

There are also requirements not directly related to the implementation of the app. The first is that upon completion of building and testing the app, it should be made available for users to download on the App Store. This requirement can be validated by the app being submitted to Apple for review, passing review and being downloaded on a user's device.

#Project Specification MKII

From researching existing apps and looking at current programming paradigms and techniques for the iOS platform it may be beneficial to look at the original project aims and redefine them based on this research.

##Functional Requirements

* Implement reminders functionality in an app
** Date based reminders
** Geo-fenced location reminders
** Preemptive location reminders using time and location


#Design

In order to implement an app with the required functionality as previously mentioned in the project specification, it is important to break what needs to be done into its core components. These components include;

* The reminder functionality
* Adding reminders
* Reminder View
* User Interface
* User Experience

##

