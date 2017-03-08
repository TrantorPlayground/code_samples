## Deck Creation & Collaboration Tool


About Deck Creation & Collaboration Tool: Deck Creation & Collaboration Tool is application software which automate every aspect of Presentation creation.
You can search slides within your organization, request a new slide design from your team or a external team,
get notified of on going developemt on it, manage different version of a slide and combine a no of slide into
a power point presentation with Click of button.

It treats a Presentation as a project and make it reusable within the organization.

Details of files included:

Project Controller : Treat Power Point presentation as a project. The dashboard action list all the ongoing presentation within
                     the team and allow the user to create a new one. The edit action provide ability to add or edit team memeber,
                     tasks, calender events, meetings, coordinator , owner etc. It also show Time line showing different activiies
                     on project in the rcent time. User get notified of any new notification in real time.
                     
Slide Controller : It manage the process of power point creation. The core action of this controller is desktop. The view is
                   broadly divided into PPT carousel, Slide Library and incoming section, User can select any slides from 
                   library or the incoming section and drag it into PPt carousel, he can suffel the slide within the PPT carousel.
                   a Slide within the library can be searched based on text, category or tags.When user click Generate PPT button
                   all the slides in the carousel are sent to Merger server which combine it in PPt and send it to the user email.
                   
User Model: It handles different user associations, authentication and authorization

Project Model : It handles project business logic like due date, team members, tasks, meetings etc

Slide Model : It implements Slide search within the library based on category, text and tags

Lib/custom_cropper : It override paperclip's trasform method to support image cropping

Lib/drive : It syncs google slide from user's google drive in the application

Lib/tasks/import_country_states.rake : It import country and state list from CSV into DB
