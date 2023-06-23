# Project Overview
After purchasing a new bike, I found myself wanting to maintain it more effectively and keep track of my cycling distance. However, I soon realized that various components were being mounted and demounted between rides, and I often switched tires or wheels based on different riding conditions. This led me to the idea of creating the track-gear, a user-friendly application designed to help cycling enthusiasts like myself manage their bike maintenance schedules effortlessly.

The track-gear is not only a practical tool but also serves as an educational resource for those interested in learning about web development. This project was built entirely from scratch, without relying on any frameworks, using Ruby as the primary programming language. The development process, along with the various decisions made throughout the project, have been documented in detail on my [blog](https://www.tobiaszwaszak.com/posts/), providing valuable insights and lessons for aspiring developers.

With the track-gear, you can easily log and monitor the status of your bike's components, ensuring they receive timely service and replacement when needed. The app provides a simple interface and track distance from external services.

# Tech stack
- Ruby 3.2.2
- Rack 3.0
- sqlite 3.x
- plain HTML and JS for frontend part

# Installation and Usage Instructions
- Clone the repository to your local machine.
- Install the required dependencies using `bundle install`.
- Setup database with `rake db:create` & `rake db:migrate`
- Start the application with the command `rackup`.
- Open your web browser and visit http://localhost:9292 to access the app.

# Testing
The track-gear includes a comprehensive suite of tests to ensure the quality and reliability of the application. The tests are written using RSpec. To run the tests, execute the following command:
```
RACK_ENV=test rspec
```
This command will trigger the execution of both unit tests and integration tests.

# License:
The track-gear is released under the MIT License. Please review the license file for more information.

# Contact Information:
For any questions, feedback, or support, feel free to reach out to our team at tobiaszwaszak@gmail.com.
